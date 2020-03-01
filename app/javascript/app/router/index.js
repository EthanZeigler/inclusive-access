import Vue from 'vue';
import VueRouter from 'vue-router';

Vue.use(VueRouter);

import Home from '../../app/views/home/Index.vue';
import LocationIndex from '../../app/views/location/Index.vue';
import LocationNew from '../../app/views/location/New.vue';

const routes = [
    { path: '/', component: Home },
    { path: '/location/new', component: LocationNew },
    { path: '/location/:id', component: LocationIndex },
];

export default new VueRouter({
    mode: 'history',
    routes // short for `routes: routes`
});