struct BlockchainClient {
    rpc: String,
    private_key: String,
    account_address: String,
}
impl BlockchainClient {
    fn new(rpc_url: String, key: String, address: String) -> Self {
        BlockchainClient {rpc: rpc_url, private_key: key, account_address: address}
    }

    fn send_transaction(&self, function_name: String) {

    }
    fn send_transfer(&self, function_name: String) {

    }
    fn send_call(&self, function_name: String) {

    }
    fn get_nonce(&self) {

    }
    fn get_estimationfee(&self) {

    }
    fn get_balance(&self) {

    }
}