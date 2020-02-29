<template>
    <div>
        <p>Hello! I am <i>not</i> /! :)</p>

        <div id="map"></div>
    </div>
</template>
<style>
    #map {
        height: 400px;
    }
</style>

<script>
    import Map from 'ol/Map.js';
    import View from 'ol/View.js';
    import Polygon from 'ol/geom/Polygon.js';
    import Draw, {createRegularPolygon, createBox} from 'ol/interaction/Draw.js';
    import {Tile as TileLayer, Vector as VectorLayer} from 'ol/layer.js';
    import {OSM, Vector as VectorSource} from 'ol/source.js';
    import 'ol/ol.css';

    export default {
        data() {
            return {
            }
        },
        methods: {
        },
        mounted() {
            //this.setup();
            var raster = new TileLayer({
                source: new OSM()
            });

            var source = new VectorSource({wrapX: false});

            var vector = new VectorLayer({
                source: source
            });

            var map = new Map({
                layers: [raster, vector],
                target: 'map',
                view: new View({
                    center: [-11000000, 4600000],
                    zoom: 4
                })
            });

            var draw; // global so we can remove it later
            function addInteraction() {
                var geometryFunction;
                draw = new Draw({
                    source: source,
                    type: 'Circle',
                    geometryFunction: geometryFunction
                });
                map.addInteraction(draw);
            }

            addInteraction();

            draw.on('drawend', async () => {
                /*
                 WARNING: HACK!!!!!!!!!!!
                 BAD HACK!!!!!!!!!!!!!!!

                 Seemingly, drawend is fired before the feature array is updated.
                 We have to wait for a change, probably.
                */
                let cur = vector.getSource().getFeatures().length;
                console.log(draw);
                let tries = 0;
                while (vector.getSource().getFeatures().length === cur &&
                    tries <= 40) {
                    await new Promise(r => setTimeout(r, 25));
                    tries++;
                }
                let features = vector.getSource().getFeatures();
                let feature = features[features.length - 1];
                console.log(feature);
                console.log(feature.values_.geometry.getRadius());
            });
        }
    }
</script>