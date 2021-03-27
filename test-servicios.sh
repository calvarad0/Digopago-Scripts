#!/bin/bash

# Test de de los servicios con digitel
# 
# Usar con -v para un prueba detallada de los servicios, sin parametro prueba solo que el serv responda
#
# Servicio - Pago de factura desde terceros
#   Ambiente QA: 
#       Servicios: 
#	      IP: 200.71.242.80 Puerto: 9702 
#       URL:
#           https://200.71.242.80:9702/CalculateBillingAmountPostpaid/CalculateBillingAmountPostpaidService?wsdl
#           https://200.71.242.80:9702/ApplyBillPaymentOrchestrator/ApplyBillPaymentOrchestratorService?wsdl
#
#   Ambiente Producción:
#       Servicios:
#           IP: 200.71.242.19 Puerto: 9012 
#       URL: 
#   	   https://200.71.242.19:9012/CalculateBillingAmountPostpaid/CalculateBillingAmountPostpaidService?wsdl
#          https://200.71.242.19:9012/ApplyBillPaymentOrchestrator/ApplyBillPaymentOrchestratorService?wsd
#
# Servicio - Recargas Virtuales:
#   Ambiente QA:
#       Servicios: 
#	      IP: 200.71.241.109 Puerto: 9701 
#       URL:
#	      Servicio de Validación: https://200.71.241.109:9701/WSValidateRechargeFacade/WSValidateRechargeFacade?wsdl
#	      Servicio de Recarga: https://200.71.241.109:9701/WSRechargeFacade/RechargeFacade?wsdl
#	      Servicio de Anulación de validación: https://200.71.241.109:9701/WSAnulationRechargeFacade/AnulationRechargeFacade?wsdl
#
#	Ambiente Producción:
#       Servicios: 
#	      IP: 200.71.241.110 Puerto: 9443
#       URL:
#	      Servicio de Validación: https://200.71.241.110:9443/WSValidateRechargeFacade/WSValidateRechargeFacade?wsdl
#	      Servicio de Recarga: https://200.71.241.110:9443/WSRechargeFacade/RechargeFacade?wsdl 
#	      Servicio de Anulación de validación: https://200.71.241.110:9443/WSAnulationRechargeFacade/AnulationRechargeFacade?wsdl

getHttpCode() {
   cod=$(curl --connect-timeout 3 --write-out "%{http_code}" --silent --output /dev/null -k "$1")
   
    if [ "$cod" -lt 100 ]; then
        echo "HTTP response: $cod [\e[0;31mERROR\e[0m] - Fallo la comunicación"
    elif [ "$cod" -ge 100 ] &&  [ "$cod" -lt 200 ]; then
        echo "HTTP response: $cod [\e[0;31mERROR\e[0m] - INFORMATIONA RESPONSE"
    elif [ "$cod" -ge 200 ] &&  [ "$cod" -lt 300 ]; then
        echo "HTTP response: $cod [\e[0;32mOK\e[0m] - Servicio funcionando"
    elif [ "$cod" -ge 300 ] &&  [ "$cod" -lt 400 ]; then
        echo "HTTP response: $cod [\e[0;31mEROR\e[0m] - REDIRECT"
    elif [ "$cod" -ge 400 ] &&  [ "$cod" -lt 500 ]; then
        echo "HTTP response: $cod [\e[0;31mEROR\e[0m] - Client errors"
    elif [ "$cod" -ge 500 ] &&  [ "$cod" -lt 600 ]; then
        echo "HTTP response: $cod [\e[0;31mEROR\e[0m] - Server error"
    else
        echo "HTTP response: $cod [\e[0;31mEROR\e[0m] - Indeterminado"
    fi
    
    return $resp
}
     

# Servicio de Factura
servFact='1.1.1.1:443' # QA
#servFact=200.71.242.80:9702 # QA
#servFact=200.71.242.19:9012 # PROD

echo "\nServicio de Factura ($servFact)" 
getHttpCode $servFact
#echo "\nServicio de Factura - $?" 

# Servicio - Recargas Virtuales:
servRecarga='1.1.1.1:80' # QA
#servRecarga=200.71.241.109:9701 # QA
#servRecarga=200.71.241.110:9443 # PROD

echo "\nServicio de Recarga ($servRecarga)" 
getHttpCode $servRecarga
#echo "\nServicio de Recarga - $?" 

# TEST de todos los servicos 1 a 1
# 
# Contenido del test en QA
# echo "Test Factura - 200.71.242.40"
# curl --connect-timeout 3 -k https://200.71.242.80:9702/ApplyBillPaymentOrchestrator/ApplyBillPaymentOrchestratorService?wsdl
# curl --connect-timeout 3 -k https://200.71.242.80:9702/CalculateBillingAmountPostpaid/CalculateBillingAmountPostpaidService?wsdl
# echo "Test Recarga - 200.71.241.109"
# curl --connect-timeout 3 -k https://200.71.241.109:9701/WSRechargeFacade/RechargeFacade?wsdl
# curl --connect-timeout 3 -k https://200.71.241.109:9701/WSAnulationRechargeFacade/AnulationRechargeFacade?wsdl
# 
# Contenido en Prod
# echo "Test recarga 200.71.241.110"
# curl --connect-timeout 3 -k https://200.71.241.110:9443/WSRechargeFacade/RechargeFacade?wsdl
# curl --connect-timeout 3 -k https://200.71.241.110:9443/WSAnulationRechargeFacade/AnulationRechargeFacade?wsdl
# echo "Test factura 200.71.242.19"
# curl --connect-timeout 3 -k https://200.71.242.19:9012/ApplyBillPaymentOrchestrator/ApplyBillPaymentOrchestratorService?wsdl
# curl --connect-timeout 3 -k https://200.71.242.19:9012/CalculateBillingAmountPostpaid/CalculateBillingAmountPostpaidService?wsdl
