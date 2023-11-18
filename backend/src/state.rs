use color_eyre::eyre::Result;
use color_eyre::Report;
use ethers::types::Address;
use futures::StreamExt;
use futures::TryStreamExt;
use sqlx::{Acquire, SqliteConnection, SqlitePool};
use std::collections::HashMap;
use std::str::FromStr;
use sqlx::sqlite::SqliteConnectOptions;
use tokio::sync::Mutex;
use url::Url;

pub struct BackendState {
    pub db: SqlitePool,
    pub address_cache: Mutex<HashMap<Address, Url>>,
}

pub async fn load_state(db_path: &str) -> Result<&'static BackendState> {
    let options = SqliteConnectOptions::new()
        .filename(db_path)
        .create_if_missing(true);
    let db = SqlitePool::connect_with(options).await?;
    let mut conn = db.acquire().await?;
    sqlx::migrate!().run(&mut conn).await?;

    let address_cache = populate_cache(&mut conn).await?;

    Ok(Box::leak(Box::new(BackendState { db, address_cache })))
}
async fn populate_cache(conn: &mut SqliteConnection) -> Result<Mutex<HashMap<Address, Url>>> {
    sqlx::query!("SELECT address, url FROM apps")
        .fetch(conn)
        .map_err(Report::new)
        .and_then(|x| async move {
            Address::from_str(&x.address)
                .map_err(Report::new)
                .and_then(|addr| {
                    Url::parse(&x.url)
                        .map_err(Report::new)
                        .map(|url| (addr, url))
                })
        })
        .try_collect()
        .await
        .map(Mutex::new)
}