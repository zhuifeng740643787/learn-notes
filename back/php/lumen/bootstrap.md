# 架构流程

- 自动加载机制
    + spl_autoload_register
    + psr-4
- 初始化容器(Application, Container)
    + bound(abstract => concrete)
        * bindings
        * instances
        * aliases
    + register instance
    + register alias
- 注册
    + 注册错误处理器
        * set_error_handler
        * set_exception_handler
        * register_shutdown_function
    + 注册路由: router
    + 开启外观模式: class_alias
    + 单例模式注册服务, singleton -> bind
    + `注册`中间件: 
        * 全局中间件：middleware
        * 路由中间件：routeMiddleware
    + 注册自定义服务
- 加载配置文件
- 设定路由
- 处理请求
    + 引导服务, boot
    + 管道处理请求：
        1. 全局中间件 
        2. 路由中间件 
        3. Controller
