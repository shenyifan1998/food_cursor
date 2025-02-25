package com.food.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

@Aspect
@Component
@Slf4j
public class LogAspect {
    private final ObjectMapper objectMapper = new ObjectMapper();

    // 定义切点
    @Pointcut("execution(* com.food.controller..*.*(..))")
    public void controllerPointcut() {}

    @Around("controllerPointcut()")
    public Object doAround(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        
        // 获取当前请求对象
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();

        // 记录请求信息
        log.info("==================== 请求开始 ====================");
        log.info("请求URL: {} {}", request.getMethod(), request.getRequestURL().toString());
        log.info("请求类方法: {}.{}", joinPoint.getSignature().getDeclaringTypeName(), joinPoint.getSignature().getName());
        log.info("请求参数: {}", objectMapper.writeValueAsString(Arrays.asList(joinPoint.getArgs())));

        // 执行目标方法
        Object result = joinPoint.proceed();

        // 记录响应信息
        log.info("响应结果: {}", objectMapper.writeValueAsString(result));
        log.info("处理耗时: {}ms", System.currentTimeMillis() - startTime);
        log.info("==================== 请求结束 ====================\n");

        return result;
    }
} 