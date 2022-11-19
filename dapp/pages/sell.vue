<template>
  <div>
    <div class="assets-container">
      <div class="content">
        <h1>Available Assets to Purchase:</h1>
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
                Price: {{ weiToETH(a.currentPrice) }} ETH
              </p>
              <div class="action-btns">
                <!-- list for sale and list for rent -->
                <button
                  v-if="a.status == '1'"
                  @click="purchase(a.id)"
                  class="form-control btn btn-dark m-2"
                >
                  Purchase Now
                </button>
                <button v-else>
                  {{ a.status == 2 ? 'SOLD' : a.status == 4 ? 'RENTED' : '?' }}
                </button>
                <button @click="alert(1)" class="form-control btn btn-dark m-2">
                  IPFS DATA
                </button>
              </div>
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
    await this.getSaleAssets()
  },
  methods: {
    convertSecToLocalTime(time_in_seconds) {
      var date = new Date(time_in_seconds * 1000)
      return date.toLocaleString()
    },
    async getSaleAssets() {
      try {
        this.assets = []
        const estateCount = await window.contract.estatesForSaleCount()
        console.log(estateCount)
        for (let i = 0; i <= estateCount; i++) {
          const estate = await window.contract.estatesForSale(i)
          if (estate.owner == '0x0000000000000000000000000000000000000000') {
            continue
          } else {
            this.assets.push({ id: i, ...estate })
          }
        }
      } catch (e) {
        console.log(e)
        window.location.href = '/'
      }
    },
    weiToETH(wei) {
      return window.ethers.utils.formatEther(wei)
    },
    purchase(id) {
      window.contract
        .purchase(id, { value: this.assets[id].currentPrice })
        .then((res) => {
          this.$bvToast.toast('Asset purchased succesfully!', {
            title: 'Success',
            variant: 'success',
            solid: true,
          })
          window.location.href = '/'
        })
        .catch((e) => {
          console.log(e)
          this.$bvToast.toast(
            'You do not have enough funds to rent this asset',
            {
              title: 'Error',
              variant: 'danger',
              solid: true,
            },
          )
        })
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
