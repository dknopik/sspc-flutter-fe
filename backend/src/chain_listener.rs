use crate::state::BackendState;
use color_eyre::Result;
use ethers::prelude::*;
use ethers::providers::Ws;
use std::str::FromStr;
use std::sync::Arc;
use ethers::abi::AbiEncode;
use crate::notification::{Notification, OpenNotification};

abigen!(Channel, "Channel.abi.json");


pub async fn listen_chain(endpoint: String, contract: String, state: &BackendState) -> Result<()> {
    println!("listener starting...");
    let provider = Provider::<Ws>::connect(&endpoint).await?;
    println!("rpc connected");
    let contract = Channel::new(Address::from_str(&contract)?, Arc::new(provider));
    let events = contract.events();
    let mut stream = events.subscribe().await?;
    println!("listening...");
    while let Some(event) = stream.next().await {
        println!("got event: {event:?}");
        match event? {
            ChannelEvents::OpenFilter(OpenFilter { id }) => {
                let (a, b, a_value, b_value, ..) = contract.channels(id).call().await?;
                if let Some(url) = state.address_cache.lock().await.get(&b) {
                    Notification::Open(OpenNotification {
                        id: id.encode_hex(),
                        proposed_by: a.to_string(),
                        their_value: a_value.to_string(),
                        our_value: b_value.to_string(),
                    }).send(url.clone()).await?;
                }
            }
            ChannelEvents::AcceptedFilter(AcceptedFilter { id }) => {}
            ChannelEvents::ClosingFilter(ClosingFilter { .. }) => {},
            ChannelEvents::ClosedFilter(ClosedFilter { id }) => {},
        }
    }
    Ok(())
}
