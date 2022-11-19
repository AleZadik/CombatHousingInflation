<template>
  <div>
    <h3>Overall Inflation Rate: {{inflation}}</h3>
    <button @click="connectWallet()">Connect Wallet</button>
    <button @click="getBalance()">Get Balance</button>
    <NuxtLink to="/sell" :class="active==='sell' ? 'active' : ''"><button>Sell</button></NuxtLink>
    <NuxtLink to="/rent" :class="active==='rent' ? 'active' : ''"><button>Rent</button></NuxtLink>
    <NuxtLink to="/myassets" :class="active==='myassets' ? 'active' : ''"><button>MyAssets</button></NuxtLink>
  </div>
</template>

<script>
export default {
  name: 'navbar',
  data() {
    return {
        balance: null,
        contract: null,
        active: null,
        inflation: null,
    }
  },
  async mounted() {
    await this.connectWallet();
    await this.getInflation();
  },
  components: {},
  methods: {
    convertSecToLocalTime(time_in_seconds) {
      var date = new Date(time_in_seconds * 1000)
      return date.toLocaleString();
    },
    async connectWallet() {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      await provider.send('eth_requestAccounts', []);
      const signer = provider.getSigner();
      this.connectContract();
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
        // '0x6Cb983756309EF5f0368D068150F10dD1BD77145',
        '0x0A8F4D0b07E93F5F52611a912263Aa33833Ae666',
        HousingInflationABI,
        signer,
      )
      console.log(this.contract);
      window.contract = this.contract;
    },

    async getInflation(){
      this.inflation = await this.contract.yoyInflation();
      this.inflation = this.inflation.substring(0, 7);
      console.log(this.inflation);
    }
  },
}
</script>

<style></style>
