# Geth-Private-Chain
這是一個關於如何在自己的網路上建立私有 ETH 鏈的教學。

## 簡介
要連上 Ethereum 就需要安裝 Ethereum Node，在這邊我們選擇使用 Golang 開發的 ETH 客戶端 Geth 來安裝 Ethereum Node。
接下來就來一步一步的學學怎麼使用 Geth，甚至如何使用 Geth 來架設自己的 Ethereum Muti-Nodes 私有鏈。



## 安裝 Geth
- 使用 Homebrew 在 macOS 上安裝 Geth:
```
$ brew tap ethereum/ethereum
$ brew install ethereum
```
- Window到官方網站下載 build 好的 Geth 執行檔:
[下載](https://geth.ethereum.org/downloads/)

- Ububtu 上使用以下指令安裝 Geth：
```
$ sudo apt-get install -y software-properties-common
$ sudo add-apt-repository -y ppa:ethereum/ethereum
$ sudo apt-get update
$ sudo apt-get install -y ethereum
```

## 以太坊 Main Net

理論上只要執行以下指令就會自動連上 chain id 為 1 的主網。
```
$ geth
```
這時候 Geth 開始同步帳本資料到你的虛擬機器了，並且會在你的本機資料夾上建立一些資料夾，.ipc 存存放連線資訊、keystore 儲存帳號資料， chaindata 資料夾下載了 Ethereum 帳本資料等。
其實這樣你的機器就已經連上 Ethereum Network，並成為 Ethereum 中的一份子了，但等待 Main Net 完成同步需要花很久的時間...而且我們也沒有真的以太幣（主網上的）來互動。


## 連上 Test Net 
Test Net 有很多個，其中有一個 chain id 為 3 的網路叫做 “Ropsten。

For testnets: use --ropsten, --rinkeby, --goerli instead (default: 1)

- Ethereum mainnet
    ```
    $ geth --mainnet  
    ```
- Goerli network: pre-configured proof-of-authority test network
    ```
    $ geth --goerli
    ```
- Rinkeby network: pre-configured proof-of-authority test network
    ```
    $ geth --rinkeby  
    ```
- Ropsten network: pre-configured proof-of-work test network
    ```
    $ geth --ropsten 
    ```

## 刪除本機資料
如果怕用完硬碟空間的話，可以把不用的帳本紀錄刪除，指令如下:
```
$ geth --testnet removedb // 刪除測試鏈資料
$ geth removedb // 刪除主鏈資料
```

## 建立自己的 Private Net

- 建立自己的 Private Net
- 要建立自己的 Ethereum Private Net 其實很簡單，只要先定義好以下這兩項就能建立自己的 Private Net：

Network id，決定自己的 network id 是什麼
Genesis 檔案，決定自己的創世區塊初始帳本資料
而當其他機器要連上這個 Private Net，就需要用一樣的 network id 及相同的 genesis 檔案（代表初始共識一致），如此就能夠連上這個 Private Net 了（一開始可能還需要提供其他 Peers 的位址給 geth 才能連上 Private Net）。

## 創世區塊
```
// genesis18.json 
{
    "config": {
        "chainId": 18,
        "homesteadBlock": 0,
        "eip150Block": 0,
        "eip150Hash":"0x0000000000000000000000000000000000000000000000000000000000000000",
        "eip155Block": 0,
        "eip158Block": 0,
        "byzantiumBlock": 0,
        "constantinopleBlock": 0
    },
    "nonce": "0x0000000000009901",
    "timestamp": "0x00",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "0x00",
    "gasLimit": "0x4c4b40",
    "difficulty": "0x0400",
    "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "coinbase": "0x0000000000000000000000000000000000000000",
    "alloc": {
    }
}
```
這邊我設定了一個 id 為 18 的私有鏈，你可以設成任何想要的數字，但請避開主鏈及知名的測試鏈（基本上 1–10 盡量不要用，或是先查一下有沒有其他測試鏈佔用該網路ID);
而 difficulty 則定義了 proof-of-work 的難度，這邊設成 0x400 其實就代表 1024，代表運算難度只有 1024，讓我們的 private chain 大約只要 10–15 秒就能產生一個區塊。

需要建立的資料路徑如下：
```
- genesis18.json 
- /nodedata0
- /nodedata1
```

這時候需要執行初始化指令（第一次需要而已）：

```
$ geth --datadir .\nodedata0 init genesis18.json
```

再來是每次要開啟鏈（ Node ）的指令：
```
geth --datadir /.ethereum/net18 --networkid 18 console
```
or
```
geth --networkid 18 --rpc --rpcaddr "0.0.0.0" --rpcport "8549" --rpcapi "web3,net,eth,admin,personal" --rpccorsdomain "*" --datadir nodedata0 --ipcdisable --allow-insecure-unlock --rpc.allow-unprotected-txs --nodiscover console
```

# 這裡是一些我已經寫好的腳本，但是Linux中才可直接使用

私有以太坊項目包含一些用於運行私有以太坊鏈的實用程序腳本。前提是你已經安裝 [geth](https://geth.ethereum.org/downloads/).

在我們的私有鏈上運行區塊鏈節點的簡單方法是使用預定義的腳本:
```shell
$ ./scripts/init.sh        # only the first time
$ ./scripts/run.sh         # every time you wish to run a blockchain node
$ ./scripts/reset.sh       # deletes your current chain and starts a new one
```

## 使用預先建立的錢包
此存儲庫附帶以下錢包，它們都有 500 以太幣:

1.  `42f072e76bdebc8f55a371565fee13d293c8696f` with password `""` (empty string)
2.  `5ad91bf68720b9281824df87680c0db60ee843ef` with the password that is hardcoded as the default password in the stemapp project (see the WalletFactory class)

在撰寫本文時，錢包 2 在 Ropsten 測試網上也有大約 0.5 個以太幣。如果您需要更多，請使用 [水龍頭](http://ipfs.b9lab.com:8080/ipfs/QmTHdYEYiJPmbkcth3mQvEQQgEamFypLhc9zapsBatQW7Y/throttled_faucet.html).

## 手動運行 geth
要設置私有區塊鏈，您需要使用新的創世塊初始化區塊鏈。該存儲庫已經包含這樣一個塊，可以根據您的要求進行修改。 

```shell
$ geth --datadir data/ init genesis.json
```

`datadir` 用於確定區塊鏈數據的儲存位置。這個目錄可以被你的第一個區塊鏈節點用作它的區塊鏈目錄。

### 啟動以太坊節點

```shell
$ geth --datadir data/ --nodiscover --identity "mainNode" --networkid 18 --rpcapi="eth, web3, personal" --rpc --rpcaddr "0.0.0.0" --rpccorsdomain "*"
```

注意一些額外的Flag：
* `nodiscover` 用於防止其他節點自動連接到您的節點（應該可以手動連接）
* `identity` 為您的節點提供了一個假名，因此更容易識別（而不是使用長地址）
* `rpc` 開啟了與該節點對話的可能性。額外的 RPC 選項讓節點可以監聽來自任何地址的 RPC 命令（所以請注意不要讓真實 Ether 的帳戶處於未鎖定狀態！）
* `networkid` 是指你的鏈的 id，它在創世塊中定義。如果使用默認值“1”，您的以太坊節點將與原始以太坊區塊鏈連接。在默認的創世區塊中，此 id 設置為“18”。
* `rpcapi` 確定此節點的可見 API 調用（由 DAPP 使用）。

與正在運行的 geth 節點交互的最簡單方法是打開第二個終端並運行 `geth attach` 命令。


# Geth Console 常用指令

開啟 Geth Node 後直接打字會有一個類似 Javascript console。
- 查看節點的全部帳號
  ```
  > eth.accounts
  []
  ```
  理論上目前節點沒有帳號，應回傳空陣列。
- 查看節點區塊數量
  ```
  > eth.blockNumber
  0
  ```
  這表示此節點目前還沒開挖任何區塊，如果有連上其他已經開挖的鏈，區塊則會被同步。
- 建立新帳號
  ```
  > personal.newAccount("123456")
  ```

# Private Chain 連結其他 Node
現在架一個 Private Chain 對我們來說不是問題了，不過現在整個 Private Chain 只有一個 Node，怎麼與其他 Node 連結呢？
另外一台現在也仿造之前的步驟裝好環境，使用相同的 Genesis.json（一定要一模一樣，例如：18）檔案建立、開啟 Private Chain，並建立好一個帳號，然後先不要進行挖礦。


當前我們兩個 Node 是分開的，並不知道彼此的存在：
```
Node A > admin.peers
[]

Node B > admin.peers
[]
```
查看節點數量
```
net.peerCount
```

想要把 B node（未開挖，無交易紀錄）連上 A node（已開挖，有交易紀錄）：

執行以下指令，得到 A node 的位址。
```
Node A > admin.nodeInfo.enode
```

以我的節點位置為例：
"enode://dbd5e2bb32a71901cb25abf8a0254bfcb3236831785553cf8607fc5479144021dffce5d0c17edee78bb66c3c852a1b605d5616092914cb4b9c0f4797ca892735@66.228.52.222:30303"

只要你的創世區塊，鏈 id 和 網路 id 與我的一樣(你的節點應該不會跟我一樣，所以必須做修改)，並且執行：
```
admin.addPeer("enode://dbd5e2bb32a71901cb25abf8a0254bfcb3236831785553cf8607fc5479144021dffce5d0c17edee78bb66c3c852a1b605d5616092914cb4b9c0f4797ca892735@66.228.52.222:30303")
```
應該就會連上我們的 18 私鏈了！

這時候再執行查看區塊數的指令，應該就會看到最新已挖到的區塊數（例如：171）
```
> eth.blockNumber
171
```

解鎖另一個有錢的帳號
```
> personal.unlockAccount("0x42f072e76bdebc8f55a371565fee13d293c8696f","")

```

進行交易
```
> eth.sendTransaction
({
	from: 		//從什麼帳戶位址
	,to:		//從什麼帳戶位址，假如要部署合約可以忽略
	,gas:		//多少 wei，預設 90000 沒用完的會退回來 
	,gasPrice:	//多少 gas，gas 單價，Enode設定
	,value:		//多少 wei 要傳 	
	,data: 		//附加資料：部署合約或呼叫合約，或也可以儲存資料，最大值為 89kb 
	,nonce:		//用於標示 Transaction 的順序，所以可以以相同的 nonce 覆蓋同 nonce 的交易
});
```
