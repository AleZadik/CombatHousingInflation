<template>
  <!-- Make a modal with overlay -->
  <div class="modal-overlay" v-if="show">
    <div class="modal" style="display: block;">
      <div class="modal-header">
        <h3 class="modal-title" style="color: black !important;">
          Add New Asset
        </h3>
        <button class="close-modal" @click="$emit('close')">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label for="name">Asset Name</label>
          <input
            type="text"
            id="name"
            v-model="asset.name"
            class="form-control"
            autocomplete="off"
          />
        </div>
        <!-- <div class="form-group">
          <label for="metadataURI">Metadata URI</label>
          <input
            type="text"
            id="metadataURI"
            v-model="asset.metadataURI"
            class="form-control"
          />
        </div> -->
        <div class="form-group">
          <label for="price">Price (ETH)</label>
          <input
            type="text"
            id="price"
            v-model="asset.price"
            class="form-control"
            autocomplete="off"
          />
        </div>
        <div class="form-group">
          <label for="location">Location</label>
          <input
            type="text"
            id="location"
            v-model="asset.location"
            class="form-control"
            autocomplete="off"
          />
        </div>
        <div class="form-group">
          <label for="ipfs-data">Extra IPFS Data</label>
          <textarea
            id="ipfs-data"
            v-model="asset.ipfsData"
            class="form-control"
          ></textarea>
        </div>
        <div class="form-group">
          <label for="ipfs-file">Upload File</label>
          <input
            type="file"
            id="ipfs-file"
            @change="onFileChange"
            class="form-control"
          />
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-dark" @click="addAsset">Add Asset</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'addModal',
  data() {
    return {
      asset: {
        name: '',
        metadataURI: '',
        price: '',
        location: '',
        ipfsData: '',
        ipfsFile: null,
      },
    }
  },
  props: ['show'],
  methods: {
    onFileChange(e) {
      this.asset.ipfsFile = e.target.files[0]
    },
    async addAsset() {
      // Get the file from the upload, and then send it to the store with all the data.
      const file = this.asset.ipfsFile
      const data = this.asset
      const r = this.$config.NFT_STORAGE
      // dispatch it to the store
      // set loading
      // commit toggleLoading
      this.$store.commit('toggleLoading');
      await this.$store.dispatch('uploadToNFTStorage', {
        file: file,
        metadata: data,
        r: r,
      })
      this.$store.commit('toggleLoading');
      // close the modal
      this.$emit('close');
    },
  },
  computed: {
    IPFS_HASH: {
      get() {
        return this.$store.state.IPFS_HASH;
      },
    },
    loading() {
      return this.$store.state.loading;
    },
  },
  watch: {
    IPFS_HASH: async function (newVal, oldVal) {
      this.asset.metadataURI = this.IPFS_HASH;
        const price = window.ethers.utils.parseEther(this.asset.price);
        this.$store.commit('toggleLoading');
        const tx = await window.contract.createEstate(
          this.asset.name,
          price,
          "https://"+this.IPFS_HASH+".ipfs.nftstorage.link/",
          this.asset.location,
        )
        this.$store.commit('toggleLoading');
        console.log(tx);
    },
  },
}
</script>

<style>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 999;
  display: flex;
  justify-content: center;
  align-items: center;
}
.modal {
  width: 500px;
  background-color: #fff;
  border-radius: 5px;
  padding: 20px;
}
.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.modal-title {
  margin: 0;
}
.close-modal {
  background-color: transparent;
  border: none;
  cursor: pointer;
}
.close-modal:hover {
  color: #000;
}
.modal-body {
  margin: 20px 0;
}
.modal-footer {
  display: flex;
  justify-content: flex-end;
}
</style>
