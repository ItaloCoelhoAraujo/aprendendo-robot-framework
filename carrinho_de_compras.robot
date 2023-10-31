*** Settings ***
Library  Browser
Suite Setup    New Browser   browser=${BROWSER}    headless=${HEADLESS}
Test Setup    New Context    viewport={'width': 1920, 'height': 1080}
Test Teardown    Close Context
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    chromium
${HEADLESS}    False
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***
O usuário deve conseguir adicionar um produto ao carrinho
    [Documentation]    Checa se o usuário consegue adicionar um produto ao carrinho
    Dado que o usuário está logado no site do Swag Labs
    Quando o usuário adiciona produto ao carrinho
    Então a pagina do carrinho deve mostrar um produto

O usuário deve conseguir remover um item do carrinho
    [Documentation]    Checa se o usuário consegue remover um item do carrinho
    Dado que o usuário adicionou vários produtos ao carinho
    Quando o usuário remove um item do carrinho
    Então o item não deve estar na lista de itens do carrinho

*** Keywords ***
Dado que o usuário está logado no site do Swag Labs
    Given New Page    https://www.saucedemo.com/
    Fill Text    input#user-name    ${USERNAME}
    Fill Text    input#password    ${PASSWORD}
    Click    input#login-button

Quando o usuário adiciona produto ao carrinho
    @{add_tocart_buttons}    Get Elements  .inventory_item >> .. >> button
    When Click    ${add_tocart_buttons}[0]

Então a pagina do carrinho deve mostrar um produto
    Then Click    a.shopping_cart_link
    Get Element Count    .cart_item    greater than    0

Dado que o usuário adicionou vários produtos ao carinho
    Dado que o usuário está logado no site do Swag Labs
    @{add_tocart_buttons}    Get Elements  .inventory_item >> .. >> button
    FOR  ${item}  IN  @{add_tocart_buttons}
        Click    ${item}
    END

Quando o usuário remove um item do carrinho
    When Click    a.shopping_cart_link
    ${total_itens}    Get Element Count    .cart_item
    @{remove_buttons}    Get Elements    .cart_item >> .. >> button
    ${product_name}    Get Text    ${remove_buttons}[0] >> ../.. >> a
    Set Test Variable    ${product_name}
    Click    ${remove_buttons}[0]

Então o item não deve estar na lista de itens do carrinho
    Then Get Element Count   "${product_name}"    should be    0    # robotcode: ignore