<template>
  <div>
    <!-- centered in the very center of the screen, big button with text logo in the middle -->
    <div class="container">
      <div class="middle-container">
        <h1>InflaAssetManagement</h1>
      </div>
    </div>


  </div>
</template>

<script>
export default {
  name: 'Index',
  data() {
    return {  
    }
  },
}
</script>

<style>
.container{
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  width: 100vw;
}
.middle-container{
  display: flex;
  justify-content: center;
  align-items: center;
  height: 50vh;
  width: 50vw;
  border-radius: 10px;
  box-shadow: 10px 10px 20px rgba(0,0,0,1);
}
</style>
