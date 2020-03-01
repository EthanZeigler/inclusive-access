<template>
    <div class="pt-4">
        <div id="map-home" class="shadow"></div>
    </div>
</template>
<style>
    #map-home {
        height: calc(100vh - 125px);
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

    export default {
        data() {
            return {
                locations: []
            }
        },
        computed: {
            id() {
                return this.$route.params.id;
            }
        },
        methods: {
            setupMap()
            {
                var raster = new TileLayer({
                    source: new OSM()
                });

                var source = new VectorSource({wrapX: false});

                var vector = new VectorLayer({
                    source: source
                });

                var map = new Map({
                    layers: [raster, vector],
                    target: 'map-home',
                    view: new View({
                        center: [-11000000, 4600000],
                        zoom: 4
                    })
                });

                for (let i = 0; i < this.locations.length; i++) {
                    let loc = this.locations[i];
                    let lon = parseFloat(loc.long);
                    let lat = parseFloat(loc.lat);
                    let radius = parseFloat(loc.radius);

                    let coordinate = fromLonLat([lon, lat]);
                    source.addFeature(new Feature(new Circle(coordinate, radius)));
                }
            }
        },
        mounted() {
            fetch('/locations.json')
                .then((response) => {
                    return response.json();
                })
                .then((data) => {
                    this.locations = data;

                    this.setupMap();
                });
        }
    }
</script>