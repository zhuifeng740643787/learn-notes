# iview3组件封装的坑

## Form组件

### Form的验证：FormItem中的子项目，如input,select会在数据改变时，自动触发on-form-change或on-form-blur事件, 如果进行封装的话，就会出现验证问题
 ```
 iview会在form-item下的iview系列的子组件（命名为A）内部触发form-item改变事件（该事件会进行数据验证，验证时取的数据是form组件的数据：model对象）,如果将子组件A进行封装的话，A对应的数据会先触发验证，然后再去同步model对象的数据，这样会导致验证时取的数据不是最新的
 ```
- 解决方法：数据同步后，再手动触发一次验证
