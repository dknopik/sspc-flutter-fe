mod calls;
mod chain_listener;
mod notification;
mod state;

use crate::calls::*;
use crate::chain_listener::listen_chain;
use crate::state::load_state;
use axum::routing::{delete, post};
use axum::Router;
use clap::Parser;
use color_eyre::eyre::Result;
use color_eyre::Report;
use futures::{FutureExt, TryFutureExt};
use std::net::SocketAddr;
use tokio::{select, try_join};

#[derive(clap::Parser)]
struct Args {
    /// Launch listening on this port
    port: u16,

    /// Sqllite file
    #[arg(long, default_value = "sspc_backend.db")]
    db: String,

    /// Url to an ethirium node (websocket required)
    #[arg(long)]
    node: String,

    /// Contract address
    #[arg(long, default_value = "0xa23cd49f677431f4eb23226b8c2150e24912070f")]
    contract: String,
}

#[tokio::main(flavor = "multi_thread")]
async fn main() -> Result<()> {
    let args = Args::parse();

    color_eyre::install()?;
    tracing_subscriber::fmt::init();

    let state = load_state(&args.db).await?;

    let chain_listener = tokio::spawn(listen_chain(args.node, args.contract, state));

    let app = Router::new()
        .route("/app", post(register_app))
        .route("/app/:id", delete(unregister_app).get(check_app))
        .with_state(state);
    let server =
        axum::Server::bind(&SocketAddr::new("127.0.0.1".parse()?, args.port))
            .serve(app.into_make_service());

    select!(
        r = chain_listener => r.map_err(Report::new).and_then(|x| x),
        r = server => r.map_err(Report::new),
        else => Ok(())
    )
}
