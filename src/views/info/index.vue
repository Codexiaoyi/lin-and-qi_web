<template>
  <div class="info-main">
    <div v-if="loading">loading</div>
    <div v-else v-html="articleContent" class="entry-content"></div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue-demi'
import { useRoute } from 'vue-router'
import { getArticleInfo } from '../../api/article'

const loading = ref(true)
const articleContent = ref({})
const route = useRoute()
const query = route.query

const getInfo = () => {
  getArticleInfo(query.cate, query.title).then((res) => {
    loading.value = false
    articleContent.value = res
  })
}
getInfo()
</script>

<style scoped>
.info-main {
  overflow: scroll;
}
</style>