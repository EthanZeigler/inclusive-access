import Vue from 'vue';
import VueRouter from 'vue-router';

Vue.use(VueRouter);

import Home from '../../app/views/home/Index.vue';
import Test from '../../app/views/test/Index.vue';

const routes = [
    { path: '/', component: Home },
    { path: '/test', component: Test }
];

export default new VueRouter({
    mode: 'history',
    routes // short for `routes: routes`
});