use serde::Serialize;
use tokio::sync::OnceCell;
use url::Url;
use color_eyre::Result;

static CLIENT: OnceCell<reqwest::Client> = OnceCell::const_new();

#[derive(Serialize)]
pub enum Notification {
    Open(OpenNotification),
    Accept(AcceptNotification),
}
#[derive(Serialize)]
pub struct OpenNotification {
    pub id: String,
    pub proposed_by: String,
    pub their_value: String,
    pub our_value: String,
}

#[derive(Serialize)]
pub struct AcceptNotification {
    pub id: String,
}

impl Notification {
    pub async fn send(&self, to: Url) -> Result<()> {
        let client = CLIENT.get_or_try_init(|| async { reqwest::Client::builder().build() }).await?;
        client.post(to).body(serde_json::to_string(self)?).send().await?;
        Ok(())
    }
}
