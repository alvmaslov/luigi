<template lang='pug'>
.home
  h1 Luigi
  textarea.txt(v-model='txt')
  button(@click='share') Share
</template>

<script lang='coffee'>
#// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'home',
  components: {
    HelloWorld
  }
  data: ->
    txt: ''
  methods:
    share: ->
      console.log @txt
      @axios.post( '/api/share', {txt: @txt} )
        .then  (resp) =>
          console.log resp
        .catch (err) =>
          console.error err
}
</script>

<style scoped>
</style>