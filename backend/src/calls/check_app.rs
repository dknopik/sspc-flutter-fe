use axum::extract::Path;
use axum::http::StatusCode;

pub async fn check_app(Path(id): Path<i64>) -> StatusCode {
    todo!()
}
