#!/bin/bash

PROM_RBAC=rbac_prometheus.yaml
ALERT_SECRET=secret_alertmanager.yaml
PROM_ALERT_CFG=prometheus-alertmanager-cfg.yaml
ALERT_SVC=alertmanager-svc.yaml
PROM_SVC=prometheus-svc.yaml
PROM_ALERT_DEPLOY=prometheus-alertmanager-deploy.yaml

# Check if the yaml files are all present, proceed with kubernetes application order
if [ -f "$PROM_RBAC" ] && [ -f "$ALERT_SECRET" ] && [ -f "$PROM_ALERT_CFG" ] && [ -f "$ALERT_SVC" ] && [ -f "$PROM_SVC" ] && [ -f "$PROM_ALERT_DEPLOY" ]; then
    echo "Required yaml files are present" 
    echo "Starting application order for RBAC..."
    kubectl apply -f "$PROM_RBAC" || {
        echo "Application failure, Aborting..." >&2
        exit 1
    }
    echo "Starting application order for alertmanager secret..."   
    kubectl apply -f "$ALERT_SECRET" || {
        echo "Application failure, Aborting..." >&2
        exit 1
    }
    echo "Starting application order for prometheus and alertmanager's configmap..." 
    kubectl apply -f "$PROM_ALERT_CFG" || {
        echo "Application failure, Aborting..." >&2
        exit 1    
    } 
    echo "Starting application order for alertmanager service..." 
        kubectl apply -f "$ALERT_SVC" || {
        echo "Application failure, Aborting..." >&2
        exit 1
    } 
    echo "Starting application order for prometheus service..." 
        kubectl apply -f "$PROM_SVC" || {
        echo "Application failure, Aborting..." >&2
        exit 1
    } 
    echo "Starting application order for prometheus and alertmanager deployment..." 
        kubectl apply -f "$PROM_ALERT_DEPLOY" || {
        echo "Application failure, Aborting..." >&2
        exit 1
    }
else 
    echo "Required yaml files are not all present, aborting application order..." >&2
    exit 1
fi