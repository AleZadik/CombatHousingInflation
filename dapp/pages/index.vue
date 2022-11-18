<template>
  <div>
    TEST
    <button @click="connectWallet()">Connect Wallet</button>
    <button @click="getBalance()">Get Balance</button>
    <div v-if="balance">
      <p>Balance: {{ balance }} Wei</p>
    </div>
    <h1>Create Asset:</h1>
    <!-- name, URI, price, location -->
    <input
      type="text"
      class="form-control"
      v-model="asset.name"
      placeholder="Name"
    />
    <input
      type="text"
      class="form-control"
      v-model="asset.price"
      placeholder="Price"
    />
    <input
      type="text"
      class="form-control"
      v-model="asset.metadataURI"
      placeholder="URI"
    />
    <input
      type="text"
      class="form-control"
      v-model="asset.location"
      placeholder="Location"
    />
    <button @click="createAsset()">Create Asset</button>

    <h1>List Assets:</h1>
    <button @click="getAssets()" class="form-control">List Assets</button>
    <div v-if="assets" class="component mt-2">
      <div v-for="a in assets" style="color: white;height: 200px;overflow-y: scroll;margin:50px;padding:10px;" class="card">
        <p>Asset Name: {{ a.name }}</p>
        <p>Asset Owner: {{ a.owner }}</p>
        <p>Asset Initial Price: {{ a.initialPrice }}</p>
        <p>Asset Current Price: {{ a.currentPrice }}</p>
        <p>Asset URI: {{ a.metadataURI }}</p>
        <p>Asset Location: {{ a.location }}</p>
        <p>Asset Status: {{ a.status }}</p>
        <p>Asset Creation Date: {{ convertSecToLocalTime(a.creationDate) }}</p>
        <p>Asset Rent Price: {{ a.rentPrice }}</p>
        <p>Asset Rent Duration: {{ a.rentDuration }}</p>
        <p>Asset Renter: {{ a.renter }}</p>
        <p>Asset Rent Ends: {{ a.rentEnds }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Index',
  data() {
    return {
      message: 'Hello World!',
      balance: null,
      contract: null,
      asset: {
        name: '',
        metadataURI: '',
        price: '',
        location: '',
      },
      assets: null,
    }
  },
  async mounted() {
    await this.connectWallet()
  },
  components: {},
  methods: {
    convertSecToLocalTime(time_in_seconds) {
      var date = new Date(time_in_seconds * 1000)
      return date.toLocaleString()
    },
    async connectWallet() {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      await provider.send('eth_requestAccounts', [])
      const signer = provider.getSigner()
      this.connectContract()
    },
    async getBalance() {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      const signer = provider.getSigner()
      this.balance = await signer.getBalance()
      console.log(this.balance)
    },
    // function to connect to the "HousingInflation" contract at the address "0x6Cb983756309EF5f0368D068150F10dD1BD77145"
    // HousingInflationABI is the ABI of the contract
    async connectContract() {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      const signer = provider.getSigner()
      const HousingInflationABI = [
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '_estateId',
              type: 'uint256',
            },
          ],
          name: 'concludeRent',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'string',
              name: '_name',
              type: 'string',
            },
            {
              internalType: 'uint256',
              name: '_initialPrice',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: '_metadataURI',
              type: 'string',
            },
            {
              internalType: 'string',
              name: '_location',
              type: 'string',
            },
          ],
          name: 'createEstate',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: false,
              internalType: 'string',
              name: 'name',
              type: 'string',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'initialPrice',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'string',
              name: 'metadataURI',
              type: 'string',
            },
            {
              indexed: false,
              internalType: 'uint8',
              name: 'status',
              type: 'uint8',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'creationDate',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'string',
              name: 'location',
              type: 'string',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'rentPrice',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'rentDuration',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'renter',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'rentEnds',
              type: 'uint256',
            },
          ],
          name: 'EstateCreated',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: false,
              internalType: 'uint256',
              name: 'estateId',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'price',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'duration',
              type: 'uint256',
            },
          ],
          name: 'EstateListedForRent',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: false,
              internalType: 'uint256',
              name: 'estateId',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'price',
              type: 'uint256',
            },
          ],
          name: 'EstateListedForSale',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: false,
              internalType: 'uint256',
              name: 'estateId',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'buyer',
              type: 'address',
            },
          ],
          name: 'EstatePurchased',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: false,
              internalType: 'uint256',
              name: 'estateId',
              type: 'uint256',
            },
          ],
          name: 'EstateRentConcluded',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: false,
              internalType: 'uint256',
              name: 'estateId',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'renter',
              type: 'address',
            },
          ],
          name: 'EstateRented',
          type: 'event',
        },
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '_estateId',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: '_price',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: '_duration',
              type: 'uint256',
            },
          ],
          name: 'listForRent',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '_estateId',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: '_price',
              type: 'uint256',
            },
            {
              internalType: 'bool',
              name: '_followInflation',
              type: 'bool',
            },
          ],
          name: 'listForSale',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '_estateId',
              type: 'uint256',
            },
          ],
          name: 'purchase',
          outputs: [],
          stateMutability: 'payable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '_estateId',
              type: 'uint256',
            },
          ],
          name: 'rentEstate',
          outputs: [],
          stateMutability: 'payable',
          type: 'function',
        },
        {
          inputs: [],
          name: 'requestYoyInflation',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [],
          name: 'estateCount',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          name: 'estates',
          outputs: [
            {
              internalType: 'string',
              name: 'name',
              type: 'string',
            },
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'initialPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'currentPrice',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'metadataURI',
              type: 'string',
            },
            {
              internalType: 'uint8',
              name: 'status',
              type: 'uint8',
            },
            {
              internalType: 'uint256',
              name: 'creationDate',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'location',
              type: 'string',
            },
            {
              internalType: 'uint256',
              name: 'rentPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'rentDuration',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'renter',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'rentEnds',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          name: 'estatesForRent',
          outputs: [
            {
              internalType: 'string',
              name: 'name',
              type: 'string',
            },
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'initialPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'currentPrice',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'metadataURI',
              type: 'string',
            },
            {
              internalType: 'uint8',
              name: 'status',
              type: 'uint8',
            },
            {
              internalType: 'uint256',
              name: 'creationDate',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'location',
              type: 'string',
            },
            {
              internalType: 'uint256',
              name: 'rentPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'rentDuration',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'renter',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'rentEnds',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [],
          name: 'estatesForRentCount',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          name: 'estatesForSale',
          outputs: [
            {
              internalType: 'string',
              name: 'name',
              type: 'string',
            },
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'initialPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'currentPrice',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'metadataURI',
              type: 'string',
            },
            {
              internalType: 'uint8',
              name: 'status',
              type: 'uint8',
            },
            {
              internalType: 'uint256',
              name: 'creationDate',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'location',
              type: 'string',
            },
            {
              internalType: 'uint256',
              name: 'rentPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'rentDuration',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'renter',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'rentEnds',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [],
          name: 'estatesForSaleCount',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: '_owner',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: '_index',
              type: 'uint256',
            },
          ],
          name: 'getOwnerEstateByIndex',
          outputs: [
            {
              internalType: 'string',
              name: '',
              type: 'string',
            },
            {
              internalType: 'address',
              name: '',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: '',
              type: 'string',
            },
            {
              internalType: 'uint8',
              name: '',
              type: 'uint8',
            },
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: '',
              type: 'string',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: '_owner',
              type: 'address',
            },
          ],
          name: 'getOwnerEstateCount',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: '',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          name: 'ownerEstates',
          outputs: [
            {
              internalType: 'string',
              name: 'name',
              type: 'string',
            },
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'initialPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'currentPrice',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'metadataURI',
              type: 'string',
            },
            {
              internalType: 'uint8',
              name: 'status',
              type: 'uint8',
            },
            {
              internalType: 'uint256',
              name: 'creationDate',
              type: 'uint256',
            },
            {
              internalType: 'string',
              name: 'location',
              type: 'string',
            },
            {
              internalType: 'uint256',
              name: 'rentPrice',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'rentDuration',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'renter',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'rentEnds',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [],
          name: 'yoyInflation',
          outputs: [
            {
              internalType: 'string',
              name: '',
              type: 'string',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
      ]
      this.contract = new ethers.Contract(
        '0x6Cb983756309EF5f0368D068150F10dD1BD77145',
        HousingInflationABI,
        signer,
      )
      console.log(this.contract)
    },

    async createAsset() {
      // call contract's function createEstate(string,uint256,string,string)
      const tx = await this.contract.createEstate(
        this.asset.name,
        this.asset.price,
        this.asset.location,
        this.asset.metadataURI,
      )
      console.log(tx)
    },
    // get all estates by first getting the estateCount and then calling estate(uint256) from [0 -> estateCount)
    async getAssets() {
      this.assets = []
      const estateCount = await this.contract.estateCount()
      console.log(estateCount)
      for (let i = 0; i < estateCount; i++) {
        const estate = await this.contract.estates(i)
        console.log(estate)
        console.log(estate.name)
        console.log(estate.location)
        this.assets.push(estate)
      }
    },
  },
}
</script>
