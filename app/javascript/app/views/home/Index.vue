<template>
    <div class="container-fluid pt-2">
        <div v-if="loading">
            Please wait for the locations to load...
        </div>
        <div class="row" v-else>
            <div class="col-md-8 pl-4">
                <HomeMap />
            </div>
            <div class="col-md-4 pt-2">
                <h4>Welcome to Inclusive Access!</h4>
                <p>
                    <router-link class="btn btn-outline-primary btn-block" to="/location/new" v-if="loggedIn">
                        <i class="fas fa-plus fa-fw mr-1"></i>
                        Create Location
                    </router-link>
                    <span v-else>
                        <a href="/user/sign_in">Log in</a> to create a location.
                    </span>
                </p>

                <div class="row">
                    <div class="col-md-4 pr-0">
                        <select class="custom-select" v-model="markerFilter">
                            <option value="">All Markers</option>
                            <option :value="type.id" v-for="type in markTypes" :key="'h-filter-type-' + type.id">{{ type.name }}</option>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <div class="d-flex mb-4">
                            <b-form-input v-model="searchTerm" class="mr-2 flex-1" placeholder="Search..." @keydown.enter="loadData()"></b-form-input>
                            <button type="button" class="btn btn-primary" @click.prevent="loadData()"><i class="fas fa-search fa-fw"></i></button>
                        </div>
                    </div>
                </div>

                <div v-if="data.length < 1">
                    There are no locations to display.
                </div>
                <ul v-else>
                    <li
                            v-for="loc in data"
                            :key="'location-' + loc.id"
                    >
                        <p class="mb-0">
                            <router-link
                                    :to="'/location/' + loc.id"
                            >
                                {{ loc.name }}
                            </router-link>
                        </p>
                        <ul class="mb-2" v-if="typeof assortedMarkers[loc.id] !== 'undefined' && assortedMarkers[loc.id].length > 0">
                            <li v-for="marker in assortedMarkers[loc.id]" :key="'loc-marker-' + marker.id">
                                <router-link
                                        :to="'/location/' + loc.id + '/' + marker.id"
                                >
                                    <span v-if="markerFilter === ''">[{{ getMarkType(marker) }}]</span>
                                    {{ marker.name }}
                                </router-link>
                            </li>
                        </ul>
                        <p class="mb-2" v-else><i>No markers to show</i></p>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
    import axios from 'axios';
    import HomeMap from './components/HomeMap';

    let _timer;
    export default {
        components: {
            HomeMap
        },
        data() {
            return {
                loading: true,
                data: [],
                loggedIn: this.isUserLoggedIn(),
                searchTerm: '',
                markTypes: null,
                markers: null,
                markerFilter: '',
                assortedMarkers: {}
            }
        },
        mounted() {
            this.loadData();
        },
        methods: {
            getMarkType(m) {
                return this.markTypes.find(x => x.id === m.mark_type_id).name;
            },
            async loadData() {
                clearTimeout(_timer);

                this.data = (await axios.get('/locations.json?search_term=' + encodeURIComponent(this.searchTerm))).data;

                this.markTypes = (await axios.get('/mark_types.json')).data;

                let filter = this.markerFilter === '' ? '' : '?mark_type_id=' + this.markerFilter;
                this.markers = (await axios.get('/marks.json' + filter)).data;

                // get markers per location
                this.assortedMarkers = {}; // clear
                for (let i = 0; i < this.markers.length; i++) {
                    let marker = this.markers[i];
                    if (typeof this.assortedMarkers[marker.location_id] === 'undefined') {
                        this.assortedMarkers[marker.location_id] = [];
                    }
                    this.assortedMarkers[marker.location_id].push(marker);
                }

                this.loading = false;
            }
        },
        watch: {
            searchTerm() {
                _timer = setTimeout(() => this.loadData(), 500);
            },
            markerFilter() {
                this.loadData();
            }
        }
    }
</script>
