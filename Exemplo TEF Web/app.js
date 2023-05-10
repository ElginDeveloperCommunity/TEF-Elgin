const BASE_URL = 'http://localhost:2001/tef/v1'

const historicoVendas = []

function start() {
    window.location.href = 'intent://connect/start'
}

function stop() {
    window.location.href = 'intent://connect/stop'
}

function configuracao() {
    sendPost('/configuracao', {
        nome: "Elgin Tef Web",
        versao: "0.0.1",
        textoPinpad: "TEF WEB",
        // macPinpad: "",
        producao: "0",
        estabelecimento: "estabelecimento teste",
        terminal: "000000",
        loja: ""
    })
}

function ativacao() {
    const cnpj = prompt('Insira o CNPJ com pontuação')
    sendPost('/ativacao', {
        cnpjCpf: cnpj
    })
}

function reimpressao() {
    sendGet('/adm/reimpressao')
}

function relatorio() {
    sendGet('/adm/relatorio')
}

async function venda() {
    const venda = await sendPost('/venda', null)

    if (venda.resultado.data !== undefined)
        historicoVendas.push(venda)
}

async function debito() {
    const venda = await sendPost('/venda/debito', {
        valor: '1.00'
    })

    if (venda.resultado.data !== undefined)
        historicoVendas.push(venda)
}

async function credito() {
    const venda = await sendPost('/venda/credito', {
        valor: '1.00',
        parcelas: '1',
        financiamento: '1'
    })

    if (venda.resultado.data !== undefined)
        historicoVendas.push(venda)
}

async function cancelamento() {
    const ultimaVenda = historicoVendas.pop()
    if (ultimaVenda === undefined) return alert('Primeiro realizar uma venda')

    const nsu = ultimaVenda.resultado.nsu.padStart(6, '0')
    const data = ultimaVenda.resultado.data.split(' ')[0].replace(/\/20/g, '/')
    let { valor } = ultimaVenda.resultado

    if (valor.indexOf('.') === -1)
        valor = valor + '.00'

    console.log('dados resgatados', { nsu, valor, data })

    const cancelamento = await sendPost('/adm/cancelamento', {
        nsu,
        valor,
        data
    })
}

async function sendGet(rota) {
    try {
        const responseData = await fetch(BASE_URL + rota, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'GET'
        })

        const data = await responseData.json()

        console.log('data json get', data)
        alert(JSON.stringify(data))

        return data
    } catch (err) {
        console.error('deu errooo', err)
        alert(err)
    }
}

async function sendPost(rota, body) {
    try {
        const responseData = await fetch(BASE_URL + rota, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'POST',
            body: JSON.stringify(body)
        })

        const data = await responseData.json()

        if (data.resultado !== undefined)
            data.resultado = JSON.parse(data.resultado)

        console.log('data json post', data)
        alert(JSON.stringify(data))

        return data
    } catch (err) {
        console.error('deu errooo', err)
        alert(err)
    }
}