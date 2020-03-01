<template>
    <div class="container-fluid pt-4">
        <div class="row" v-if="!loading && markTypes !== null && marks !== null">
            <div class="col-md-9 pl-4">
                <div id="map-loc" class="shadow"></div>
            </div>
            <div class="col-md-3">
                <h4>{{ location.name }}</h4>
                <p class="mb-5">{{ location.description }}</p>

                <h5>Markers</h5>
                <p>i have not implemented this yet leave me alone</p>
            </div>
        </div>
        <div class="container" v-else>
            <strong>Loading location...</strong>
        </div>
    </div>
</template>
<style>
    #map-loc {
        height: calc(100vh - 150px);
    }
</style>

<script>
    import 'ol/ol.css';

    import {fromLonLat} from 'ol/proj';
    import Map from 'ol/Map.js';
    import View from 'ol/View.js';
    import Draw from 'ol/interaction/Draw.js';
    import {Tile as TileLayer, Vector as VectorLayer} from 'ol/layer.js';
    import {OSM, Vector as VectorSource} from 'ol/source.js';
    import {Feature} from "ol";
    import Circle from "ol/geom/Circle";
    import axios from "axios";
    import Point from "ol/geom/Point";

    export default {
        data() {
            return {
                coordinates: null,
                loading: true,
                markTypes: null,
                location: null,
                marks: null,
                map: null
            }
        },
        computed: {
            id() {
                return this.$route.params.id;
            }
        },
        methods: {
            setupMap() {
                var raster = new TileLayer({
                    source: new OSM()
                });

                var source = new VectorSource({wrapX: false});

                var vector = new VectorLayer({
                    source: source
                });

                var map = new Map({
                    layers: [raster, vector],
                    target: 'map-loc',
                    view: new View({
                        center: fromLonLat([this.lon, this.lat]),
                        zoom: 16
                    })
                });

                if (this.isUserLoggedIn()) {
                    let draw = new Draw({
                        source: source,
                        type: "Point"
                    });
                    map.addInteraction(draw);

                    draw.on('drawend', async () => {
                        /*
                         WARNING: HACK!!!!!!!!!!!
                         BAD HACK!!!!!!!!!!!!!!!!
                         BAD!!!!!!!!!!!!!!!!!!!!!
                         NOT GOOD!!!!!!!!!!!!!!!!

                         Seemingly, drawend is fired before the feature array is updated.
                         We have to wait for a change, probably. So let's do that. Probably.
                        */

                        // Save the current feature array length
                        let cur = vector.getSource().getFeatures().length;

                        let tries = 0;
                        // Has the length changed yet?
                        while (vector.getSource().getFeatures().length === cur &&
                            tries <= 40 /* 40*25=1000; 1s */) {
                            await new Promise(r => setTimeout(r, 25));
                            tries++;
                        }

                        let features = vector.getSource().getFeatures();
                        let feature = features[features.length - 1];
                        console.log(feature);

                        this.coordinates = JSON.parse(JSON.stringify(feature.values_.geometry.transform('EPSG:3857', 'EPSG:4326').getCoordinates()));

                        console.log(vector);
                        source.removeFeature(feature);
                    });
                }

                let coordinate = fromLonLat([this.lon, this.lat]);
                source.addFeature(new Feature(new Circle(coordinate, this.radius)));

                (async () => {
                    while (this.marks === null) {
                        await new Promise(r => setTimeout(r, 25));
                    }
                    console.log('bruh');
                    for (let i = 0; i < this.marks.length; i++) {
                        let mark = this.marks[i];

                        let coordinate = fromLonLat(mark.long, mark.lat);
                        console.log(coordinate);
                        source.addFeature(new Feature(new Point(coordinate)));
                    }
                })();
            }
        },
        mounted() {
            axios.get('/marks.json?location_id=' + this.id)
                .then((response) => {
                    this.marks = response.data;
                })
                .catch((error) => {
                    alert('Unable to fetch mark types :(');
                    console.log(error);
                });

            axios.get('/mark_types.json')
                .then((response) => {
                    this.markTypes = response.data;
                })
                .catch((error) => {
                    alert('Unable to fetch mark types :(');
                    console.log(error);
                });

            axios.get('/locations/' + this.id + '.json')
                .then((response) => {
                    let data = response.data;

                    this.location = data;

                    this.lon = parseFloat(data.long);
                    this.lat = parseFloat(data.lat);
                    this.radius = parseFloat(data.radius);

                    this.loading = false;

                    this.$nextTick(() => {
                        this.setupMap();
                    });
                });
        }
    }
</script>