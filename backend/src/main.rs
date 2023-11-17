mod calls;
mod state;

use std::net::SocketAddr;
use axum::Router;
use axum::routing::{delete, post};
use clap::Parser;
use color_eyre::eyre::Result;
use crate::calls::*;
use crate::state::load_state;

#[derive(clap::Parser)]
struct Args {
    /// Launch listening on this port
    port: u16
}


#[tokio::main(flavor = "multi_thread")]
async fn main() -> Result<()> {
    let args = Args::parse();

    color_eyre::install()?;
    tracing_subscriber::fmt::init();

    let state = load_state().await?;

    let app = Router::new()
        .route("/app", post(register_app))
        .route("/app/:id", delete(unregister_app))
        .with_state(state);

    axum::Server::bind(&SocketAddr::new("127.0.0.1".parse()?, args.port))
        .serve(app.into_make_service()).await?;
    Ok(())
}

