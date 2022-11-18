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
    async uploadToNFTStorage(state, obj) {
      console.log(obj);
      const file = obj.file;
      const r = obj.r;
      const formData = new FormData();
      formData.append("file", file);
      axios.post('https://api.nft.storage/upload', file, {
        headers: {
          'Content-Type': 'image/*', 
          "Authorization": "Bearer " + r
        }
      }).then((response) => {
        console.log(response.data);
        state.commit('changeHASH', response.data.value.cid);
        return response.data.value.cid;
      }).catch((error) => {
        console.log(error);
      });
    },
  }