use axum::extract::Path;
use axum::http::StatusCode;

pub async fn unregister_app(Path(id): Path<u64>) -> StatusCode {
    todo!()
}
