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
    if (!venda) return alert('Antes de realizar uma venda\nativar o IDH se Android ou GP se Windows/Linux')

    if (venda.resultado.data !== undefined)
        historicoVendas.push(venda)
}

async function debito() {
    const valor = prompt('Insira um valor em R$ no formato (00.00)', '1.00')
    const venda = await sendPost('/venda/debito', {
        valor
    })

    if (!venda) return alert('Antes de realizar uma venda\nativar o IDH se Android ou GP se Windows/Linux')

    if (venda.resultado.data !== undefined)
        historicoVendas.push(venda)
}

async function credito() {
    const valor = prompt('Insira um valor em R$ no formato (00.00)', '1.00')
    const venda = await sendPost('/venda/credito', {
        valor,
        parcelas: '1',
        financiamento: '1'
    })

    if (!venda) return alert('Antes de realizar uma venda\nativar o IDH se Android ou GP se Windows/Linux')

    if (venda.resultado.data !== undefined)
        historicoVendas.push(venda)
}

async function cancelamento() {
    const ultimaVenda = historicoVendas.pop()
    if (ultimaVenda === undefined) return alert('Primeiro realizar uma venda')

    // formata valores da maneira pedida na documentação
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

    if (!cancelamento) return alert('Antes de realizar uma venda\nativar o IDH se Android ou GP se Windows/Linux')
}

async function pix() {
    const valor = prompt('Insira um valor em R$ no formato (00.00)', '1.00')
    const venda = await sendPost('/venda/credito', {
        valor,
    })

    if (!venda) return alert('Antes de realizar uma venda\nativar o IDH se Android ou GP se Windows/Linux')

    if (venda.resultado.data !== undefined)
        historicoVendas.push(venda)
}

async function intpos_venda() {
    const valor = prompt('Insira um valor em R$ no formato (00.00)', '1.00')
    await sendPost('/intpos', {
        'intpos': `000-000 = CRT\n001-000 = 123\n003-000 = ${valor}\n999-999 = 0\n`
    })
}

async function intpos_adm() {
    await sendPost('/intpos', {
        'intpos': '000-000 = ADM\n001-000 = 123\n999-999 = 0\n'
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
        alert('deu errooo\n' + err)
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

        // verifica se o retorno em resultado está definido e é um objeto
        if (data.resultado !== undefined && data.resultado.indexOf('{') !== -1)
            data.resultado = JSON.parse(data.resultado)

        console.log('data json post', data)
        alert(JSON.stringify(data))

        return data
    } catch (err) {
        console.error('deu errooo', err)
        alert('deu errooo\n' + err)
    }
}
