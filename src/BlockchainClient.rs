use web3::Error;
use web3::ethabi::Bytes;

use web3::{
    ethabi::ethereum_types::U256,
    types::{Address, TransactionRequest},
};
use web3::transports::Http;

pub struct BlockchainClient {
    rpc: String,
    private_key: String,
    account_address: String,
    web3: web3::Web3<Http>
}
impl BlockchainClient {
    pub fn new(rpc_url: String, key: String, address: String) -> Self {
        let http = web3::transports::Http::new(&rpc_url).expect("Failed to create HTTP transport");
        let web3 = web3::Web3::new(http);

        BlockchainClient {
            rpc: rpc_url,
            private_key: key,
            account_address: address,
            web3
        }
    }
    pub fn send_transfer(&self) {

    }
    pub fn send_call(&self, function_name: String) {

    }
    pub async fn get_nonce(&self, address: web3::types::Address) -> web3::Result<u64> {
        self.web3.eth().transaction_count(address, None).await;
    }
    pub fn get_estimationfee(&self) {

    }
    pub fn get_balance(&self) -> web3::Result<web3::types::U256>{
        let mut accounts = web3.eth().accounts().await?;
        let balance = web3.eth().balance(account, None).await?;
        balance
    }
    pub async fn send_transaction(&self, from: web3::types::Address, to: web3::types::Address,
                                  value: web3::types::U256, data: Bytes, private_key: &str, function_name: String)
    -> web3::Result<web3::types::H256> {
        let nonce = self.get_nonce(from).await?;

        // Build the tx object
        let transaction = TransactionRequest {
            from,
            to: Some(to),
            gas: None,
            nonce: Some(nonce),
            value: Some(value),
            data: Some(data.into()),
            ..Default::default()
        };
        // sign transaction
        let signature =
            self.web3.accounts().sign_transaction(transaction, private_key.parse().unwrap()).await?;

        // send transaction
        let result = self.web3.eth().send_raw_transaction(signature.raw_transaction).await?;

        println!("Tx succeeded with hash: {}", result);

        Ok(())
    }
}