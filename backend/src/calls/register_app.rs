use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use axum::response::Result;
use ethers::core::rand;
use serde::{Deserialize, Serialize};
use url::Url;
use crate::state::BackendState;

#[derive(Deserialize)]
pub struct RegisterAppRequest {
    notification_endpoint: Url,
    address: String,
}

#[derive(Serialize)]
pub struct RegisterAppResponse {
    id: i64,
}

pub async fn register_app(State(state): State<&BackendState>, Json(args): Json<RegisterAppRequest>) -> Result<(StatusCode, Json<RegisterAppResponse>)> {
    let address = args.address.parse().map_err(|err| StatusCode::BAD_REQUEST)?;
    let mut cache = state.address_cache.lock().await;
    if cache.get(&address).is_some() {
        // TODO: maybe return old ID?
        return Err(StatusCode::CONFLICT.into());
    }
    let id = rand::random();
    let url_string = args.notification_endpoint.to_string();
    sqlx::query!("INSERT INTO apps (id, address, url) VALUES ($1, $2, $3);",
        id,
        args.address,
        url_string)
        .execute(&state.db).await.map_err(|err| { eprintln!("{err:?}"); StatusCode::INTERNAL_SERVER_ERROR })?;
    cache.insert(address, args.notification_endpoint);
    Ok((StatusCode::CREATED, Json(RegisterAppResponse { id })))
}
