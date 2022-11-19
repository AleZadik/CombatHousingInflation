import axios from 'axios'
export const state = () => ({
    loading: false,
    IPFS_HASH: "",
  })
  
  export const getters = {
    getLoading(state) {
      return state.loading;
    }
  }
  
  export const mutations = {
    toggleLoading(state) {
      state.loading = !state.loading;
    },
    changeHASH(state, payload) {
      state.IPFS_HASH = payload;
    },
  }
  
  export const actions = {
    setLoading(state, payload) {
      console.log(payload);
      state.loading = true;
    },

    // upload the file + metadata to IPFS.
    // override the filename to be image and meta.json
    // upload the metadata to IPFS with the name meta.json
    async uploadToNFTStorage(state, obj) {
      const file = obj.file;
      const r = obj.r;
      const metadata = obj.metadata;
      const formData = new FormData();
      formData.append("file", file, "image");
      formData.append("file", new Blob([JSON.stringify(metadata)], { type: "application/json" }), "meta.json");
      axios.post('https://api.nft.storage/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          "Authorization": "Bearer " + r,
        }
      }).then((res) => {
        console.log(res);
        state.commit('changeHASH', res.data.value.cid);
      }).catch((err) => {
        console.log(err);
      }
      );
    },
  }