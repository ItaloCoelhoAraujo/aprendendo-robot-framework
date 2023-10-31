*** Settings ***
Library  Browser
Suite Setup    New Browser   browser=${BROWSER}    headless=${HEADLESS}
Test Setup    New Context    viewport={'width': 1920, 'height': 1080}
Test Teardown    Close Context
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    chromium
${HEADLESS}    False
# trocar o USERNAME para "problem_user" vai fazer este teste falhar no preenchimento dos dados do cliente
${USERNAME}    standard_user
${PASSWORD}    secret_sauce
${FIRST_NAME}    Ítalo
${LAST_NAME}    Araújo
${ZIP_CODE}    00000-00

*** Test Cases ***
O usuário deve conseguir fazer o checkout
    [Documentation]    Checa se o usuário consegue fazer o checkout com sucesso
    Dado que o usuário adicionou um produto ao carrinho
    Quando ele clicka em checkout
    E ele preenche os seus dados
    Então o sistema deve mostrar as informações da compra
    E quando ele finalizar a compra
    Então o sistema deve mostrar a mensagem de confirmação da compra

*** Keywords ***
Dado que o usuário adicionou um produto ao carrinho
    Given New Page    https://www.saucedemo.com/
    Fill Text    input#user-name    ${USERNAME}
    Fill Text    input#password    ${PASSWORD}
    Click    input#login-button
    @{add_tocart_buttons}    Get Elements  .inventory_item >> .. >> button
    When Click    ${add_tocart_buttons}[0]

Quando ele clicka em checkout
    When Click    a.shopping_cart_link
    Click    [data-test=checkout]

E ele preenche os seus dados
    And Fill Text    input#first-name    ${FIRST_NAME}
    Fill Text    input#last-name    ${LAST_NAME}
    Fill Text    input#postal-code    ${ZIP_CODE}
    Click    [data-test=continue]

Então o sistema deve mostrar as informações da compra
    Get Element Count    "Payment Information"   should be    1

E quando ele finalizar a compra
    Click    [data-test=finish]

Então o sistema deve mostrar a mensagem de confirmação da compra
    Get Element Count    "Your order has been dispatched, and will arrive just as fast as the pony can get there!"   should be    1