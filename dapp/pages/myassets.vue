<template>
  <div>
    <div class="creation-container" hidden>
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
    </div>
    <div class="assets-container">
      <div class="content">
        <h1>My Assets:</h1>
        <!-- <button @click="getAssets()" class="form-control">My Assets:</button> -->
        <div v-if="assets" class="component row mt-2">
          <div
            class="card ml-3 mr-3 mt-1 mb-1"
            style="width: 20rem; height: auto; text-align: center;"
            v-for="a in assets"
          >
            <img
              src="https://i.pinimg.com/originals/66/d9/f5/66d9f5afdc5337d3f9eac362b970c426.jpg"
              class="card-img-top"
            />
            <div class="card-body" style="text-align: center;">
              <h5 style="color: black !important;">{{ a.name }}</h5>
              <p style="color: black !important;">
                Initial Price: {{ a.initialPrice }} ETH
              </p>
              <p style="color: black !important;">
                Inflation Price: {{ a.currentPrice }} ETH
              </p>
              <div class="action-btns">
                <!-- list for sale and list for rent -->
                <button
                  v-if="
                    a.owner.toLowerCase() === account.toLowerCase() &&
                    a.status == '0'
                  "
                  @click="listForSale(a.id)"
                  class="form-control btn btn-dark m-2"
                >
                  List for Sale
                </button>
                <button v-else>
                  {{
                    a.status == 1
                      ? 'Listed for Sale'
                      : a.status == 2
                      ? 'SOLD'
                      : a.status == 3
                      ? 'Listed for Rent'
                      : a.status == 4
                      ? 'RENTED'
                      : '?'
                  }}
                </button>
                <button
                  v-if="
                    a.owner.toLowerCase() === account.toLowerCase() &&
                    a.status == '0'
                  "
                  @click="listForRent(a.id)"
                  class="form-control btn btn-dark m-2"
                >
                  List for Rent
                </button>
                <button
                  class="form-control btn btn-dark m-2"
                  v-else-if="a.status == 4"
                >
                  <span>ENDS: {{ convertSecToLocalTime(a.rentEnds) }}</span>
                </button>
                <button @click="alert(1)" class="form-control btn btn-dark m-2">
                  IPFS DATA
                </button>
              </div>
              <!-- <p>Owner: {{ a.owner }}</p>
              <p>Inflation Price: {{ a.initialPrice }}</p>
              <p>Asset Current Price: {{ a.currentPrice }}</p>
              <p>Asset URI: {{ a.metadataURI }}</p>
              <p>Asset Location: {{ a.location }}</p>
              <p>Asset Status: {{ a.status }}</p>
              <p>
                Asset Creation Date: {{ convertSecToLocalTime(a.creationDate) }}
              </p>
              <p>Asset Rent Price: {{ a.rentPrice }}</p>
              <p>Asset Rent Duration: {{ a.rentDuration }}</p>
              <p>Asset Renter: {{ a.renter }}</p>
              <p>Asset Rent Ends: {{ a.rentEnds }}</p> -->
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'myassets',
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
      account: null,
    }
  },
  components: {},
  async mounted() {
    // get account from metamask
    this.account = window.ethereum.selectedAddress
    await this.getAssets()
  },
  methods: {
    async listForSale(id) {
      try {
        let price = prompt(
          'How much ETH would you like to list this asset for?',
        )
        let followInflation = prompt(
          'Would you like to follow inflation price? (y/n)',
        )
        if (
          !price ||
          !followInflation ||
          isNaN(price) ||
          (followInflation.toLowerCase() !== 'y' &&
            followInflation.toLowerCase() !== 'n')
        ) {
          alert('Please enter a valid price and follow inflation price (y/n)')
          return
        }
        if (followInflation === 'y') {
          followInflation = true
        } else {
          followInflation = false
        }
        // transform it into a BigNumber
        price = ethers.utils.parseEther(price)
        console.log(id, price, followInflation)
        await window.contract.listForSale(id, price, followInflation)
      } catch (e) {
        console.log(e)
        // refresh the page
        window.location.href = "/";
      }
    },
    async listForRent(id) {
      try {
        let price = prompt(
          'How much ETH would you like to list this asset for rent?',
        )
        let duration = prompt(
          'How long would you like to put this asset to rent (days)?',
        )
        if (!price || !duration || isNaN(price) || isNaN(duration)) {
          alert('Please enter a valid price and duration')
          return
        }
        price = window.ethers.utils.parseEther(price)
        await window.contract.listForRent(id, price, duration)
      } catch (e) {
        console.log(e)
        window.location.href = "/";
      }
    },
    convertSecToLocalTime(time_in_seconds) {
      var date = new Date(time_in_seconds * 1000)
      return date.toLocaleString()
    },
    async createAsset() {
      try {
        // call contract's function createEstate(string,uint256,string,string)
        const tx = await window.contract.createEstate(
          this.asset.name,
          this.asset.price,
          this.asset.location,
          this.asset.metadataURI,
        )
        console.log(tx)
      } catch (e) {
        console.log(e)
        window.location.href = "/";
      }
    },
    async getAssets() {
      try {
        this.assets = []
        const estateCount = await window.contract.getOwnerEstateCount(
          this.account,
        )
        console.log(estateCount)
        for (let i = 0; i < estateCount; i++) {
          const estate = await window.contract.ownerEstates(this.account, i)
          this.assets.push({ id: i, ...estate })
        }
      } catch (e) {
        console.log(e)
        window.location.href = "/";
      }
    },
  },
}
</script>

<style scoped>
.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.card {
  border: 10px solid #000000;
  cursor: pointer;
}
.card:hover {
  border: 10px solid #000000;
  box-shadow: 0 0 11px rgba(33, 33, 33, 0.2);
  border-radius: 10px;
  opacity: 0.8;
  cursor: pointer;
}
</style>
