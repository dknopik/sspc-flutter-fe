mod register_app;
mod unregister_app;
mod check_app;

pub use register_app::register_app;
pub use unregister_app::unregister_app;
pub use check_app::check_app;

pub async fn help() -> &'static str {
    r#"
    Welcome to the SSPC backend API. It is a hackathon project, so look out for many bugs and bad security.
    We offer the following API:

    GET /
    Returns this helpful text.

    POST /app
    Body:
    {
     "notification_endpoint":"http://google.com:8080/aha",
     "address":"0x0f4A994aDbDe4114F7ea518F5230d5eF3112d9e9"
    }
    To get notified at the given URL for the given address.
    The endpoint will be tested immediately with a test notification.
    If the test notification or too many regular notifications fail, the app will be removed.
    Only a single app can be registered per address. (we should probably verify address ownership...)
    Response:
    { "id": 132 }

    GET /app/<id>
    Not yet implemented

    DELETE /app/<id>
    Not yet implemented

    POST /app/<id>/channels
    Not yet implemented
    "#
}