use axum::http::StatusCode;
use axum::Json;
use axum::response::Result;
use serde::{Deserialize, Serialize};
use url::Url;

#[derive(Deserialize)]
pub struct RegisterAppRequest {
    notification_endpoint: Url,
    address: String,
}

#[derive(Serialize)]
pub struct RegisterAppResponse {
    id: u64,
}

pub async fn register_app(Json(args): Json<RegisterAppRequest>) -> Result<(StatusCode, Json<RegisterAppResponse>)> {
    todo!()
}
