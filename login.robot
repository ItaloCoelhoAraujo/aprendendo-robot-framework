*** Settings ***
Library  Browser
Suite Setup    New Browser   browser=${BROWSER}    headless=${HEADLESS}
Test Setup    New Context    viewport={'width': 1920, 'height': 1080}
Test Teardown    Close Context
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    chromium
${HEADLESS}    False
${PASSWORD}    secret_sauce

*** Test Cases ***
Usuário válido logado com sucesso
    [Documentation]    Checa se o usuário foi logado com sucesso
    Dado que o site Swag Labs está aberto
    Quando o usuario válido tenta logar
    Então o sistema deve mostrar a lista de produtos

Usuário bloqueado falha ao tentar logar
    [Documentation]    Checa se o usuário que está bloqueado não consegue logar
    Dado que o site Swag Labs está aberto
    Quando o usuario bloqueado tenta logar
    Então o sistema deve mostrar uma mensagem de erro - bloqueado

Usuário com credenciais inválidas falha ao tentar logar
    [Documentation]    Checa se o usuário com credenciais inválidas não consegue logar
    Dado que o site Swag Labs está aberto
    Quando o usuário tenta logar com credenciais inválidas
    Então o sistema deve mostrar uma mensagem de erro - inválido

Usuário com credenciais vazias falha ao tentar logar
    [Documentation]    Checa se o usuário com credenciais vazias não consegue logar
    Dado que o site Swag Labs está aberto
    Quando o usuário tenta logar com credenciais vazias
    Então o sistema deve mostrar uma mensagem de que falta preencher o nome de usuário

*** Keywords ***
Dado que o site Swag Labs está aberto
    Given New Page    https://www.saucedemo.com/

Quando o usuario válido tenta logar
    Preencher formulário   standard_user
    And Click    input#login-button

Quando o usuario bloqueado tenta logar
    Preencher formulário   locked_out_user
    And Click    input#login-button

Quando o usuário tenta logar com credenciais inválidas
    Preencher formulário    lorde_comandante    deus_touro
    And Click    input#login-button

Quando o usuário tenta logar com credenciais vazias
    When Click    input#login-button

Então o sistema deve mostrar a lista de produtos
    Then Get Text    span.title   should be    Products

Então o sistema deve mostrar uma mensagem de erro - bloqueado
    Then Get Text    [data-test=error]    should be    Epic sadface: Sorry, this user has been locked out.

Então o sistema deve mostrar uma mensagem de erro - inválido
    Then Get Text    [data-test=error]    should be    Epic sadface: Username and password do not match any user in this service

Então o sistema deve mostrar uma mensagem de que falta preencher o nome de usuário
    Then Get Text    [data-test=error]    should be    Epic sadface: Username is required


Preencher formulário
    [Arguments]    ${username}    ${password}=${PASSWORD}
    When Fill Text    input#user-name    ${username}
    And Fill Text    input#password    ${password}