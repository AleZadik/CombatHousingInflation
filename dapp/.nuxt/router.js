import Vue from 'vue'
import Router from 'vue-router'
import { normalizeURL, decode } from 'ufo'
import { interopDefault } from './utils'
import scrollBehavior from './router.scrollBehavior.js'

const _11e07e9a = () => interopDefault(import('..\\pages\\myassets.vue' /* webpackChunkName: "pages/myassets" */))
const _dd4ce686 = () => interopDefault(import('..\\pages\\rent.vue' /* webpackChunkName: "pages/rent" */))
const _153f6754 = () => interopDefault(import('..\\pages\\sell.vue' /* webpackChunkName: "pages/sell" */))
const _38946704 = () => interopDefault(import('..\\pages\\index.vue' /* webpackChunkName: "pages/index" */))

const emptyFn = () => {}

Vue.use(Router)

export const routerOptions = {
  mode: 'history',
  base: '/',
  linkActiveClass: 'nuxt-link-active',
  linkExactActiveClass: 'nuxt-link-exact-active',
  scrollBehavior,

  routes: [{
    path: "/myassets",
    component: _11e07e9a,
    name: "myassets"
  }, {
    path: "/rent",
    component: _dd4ce686,
    name: "rent"
  }, {
    path: "/sell",
    component: _153f6754,
    name: "sell"
  }, {
    path: "/",
    component: _38946704,
    name: "index"
  }],

  fallback: false
}

export function createRouter (ssrContext, config) {
  const base = (config._app && config._app.basePath) || routerOptions.base
  const router = new Router({ ...routerOptions, base  })

  // TODO: remove in Nuxt 3
  const originalPush = router.push
  router.push = function push (location, onComplete = emptyFn, onAbort) {
    return originalPush.call(this, location, onComplete, onAbort)
  }

  const resolve = router.resolve.bind(router)
  router.resolve = (to, current, append) => {
    if (typeof to === 'string') {
      to = normalizeURL(to)
    }
    return resolve(to, current, append)
  }

  return router
}
