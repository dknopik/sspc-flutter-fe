use axum::extract::Path;
use axum::http::StatusCode;

pub async fn unregister_app(Path(id): Path<i64>) -> StatusCode {
    todo!()
}
