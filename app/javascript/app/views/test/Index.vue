<template>
    <div>
        <p>Hello! I am <i>not</i> /! :)</p>

        <vl-map :load-tiles-while-animating="true" :load-tiles-while-interacting="true" style="height: 400px" ref="map">
            <vl-view :zoom.sync="zoom" :center.sync="center" :rotation.sync="rotation"></vl-view>

            <vl-layer-tile id="osm">
                <vl-source-osm></vl-source-osm>
            </vl-layer-tile>
        </vl-map>
    </div>
</template>

<script>
    import {
        Vector as VectorLayer
    } from 'ol/layer';
    import {
        Vector as VectorSource
    } from 'ol/source';
    import Draw from "ol/interaction/Draw";

    export default {
        data() {
            return {
                zoom: 2,
                center: [0, 0],
                rotation: 0,
            }
        },
        methods: {
            async setup() {
                // delay until the map is ready
                while (typeof this.$refs.map.$map === 'undefined') {
                    await new Promise(r => setTimeout(r, 100));
                }

                let map = this.$refs.map.$map;
                console.log(map);

                var source = new VectorSource({
                    wrapX: false
                });

                var vector = new VectorLayer({
                    source: source
                });

                var geometryFunction;
                var draw = new Draw({
                    source: source,
                    type: 'Circle',
                    geometryFunction: geometryFunction
                });
                map.addInteraction(draw);
            }
        },
        mounted() {
            this.setup();
        }
    }
</script>