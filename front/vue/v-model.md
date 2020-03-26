# v-model
封装组件，用v-model实现组件props双向绑定

## 代码示例
```html
<div id="app">
   <my-test v-model="formData.test"></my-test>
    <my-test1 v-model="formData.test1"></my-test1>
</div>
<script>
    Vue.component('my-test', {
        props: {
          modelValue: {
            type: String,
            default: '',
          }
        },
        model: {
          prop: 'modelValue',
          event: 'model-change',
        },
        data () {
          return {
            modelMidValue: this.modelValue
          }
        },
        watch: {
          modelValue(val) {
            this.modelMidValue = val;
          },
          modelMidValue(val) {
            this.$emit('model-change', val);
          }
        },
        methods: {
          handleClick: function () {
            this.modelMidValue = '123123'
          }
        },
        mounted() {
        },
        template: `
          <div class="modal" :value="modelValue">
            <h1 @click="handleClick">{{ modelMidValue }}</h1>
          </div>
        `
    })

    Vue.component('my-test1', {
        props: {
          modelValue: {}
        },
        // 定义v-model机制的prop和事件类型
        model: {
          prop: 'modelValue',
          event: 'model-change',
        },
        watch: {
          modelValue(val) {
            this.text = val;
          },
          modelMidValue(val) {
            this.$emit('model-change', val);
          }
        },
        data () {
          return {
            modelMidValue: this.modelValue //// 实现v-model机制的过渡数据
          }
        },
        methods: {},
        mounted() {},
        render: function (createElement) {
          const componentName = 'my-test'
          return createElement(
            componentName,// 标签名称
            {
              class: this.customerClassName,
              props: {
                'model-value': this.modelValue,
              },
              on: {
                'model-change': (value) => {
                  this.modelMidValue = value
                },
              }
            }
          )
        }
    })

    new Vue({
        el: '#app',
        data: function () {
          return {
            formData: {
              test: 'aaa',
              test1: 'bbb'
            }
          }
        }
    )    
</script>
```