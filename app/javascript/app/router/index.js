import Vue from 'vue';
import VueRouter from 'vue-router';

Vue.use(VueRouter);

import Home from '../../app/views/home/Index.vue';

const routes = [
    { path: '/', component: Home }
];

export default new VueRouter({
    routes // short for `routes: routes`
});