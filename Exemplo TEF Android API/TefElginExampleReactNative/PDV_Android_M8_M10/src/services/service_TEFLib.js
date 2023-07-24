import { DeviceEventEmitter, NativeModules } from "react-native"

const { TEFModule } = NativeModules

export const tefTransaction = async ({ method, hook, ...data }) => {
    if (hook) DeviceEventEmitter.addListener('TefHandler', (event) => {
        hook(event.message)
        if (event.type == 5) {
            DeviceEventEmitter.removeAllListeners('TefHandler');
            hook("")
        }
    });


    if (method === 'Crédito') return tefCreditTransaction(data)
    if (method === 'Débito') return tefDebitTransaction(data)
    if (method === 'PIX') return tefPixTransaction(data)
}

const transactionResult = async () => new Promise((resolve, reject) => {
    DeviceEventEmitter.addListener('tefResult', async (event) => {
        event = JSON.parse(event)
        DeviceEventEmitter.removeAllListeners('tefResult')
        resolve(event)
    })
})


const tefCreditTransaction = async (data) => {
    TEFModule.startCreditTransaction(`${data.value}`, `${data.parc_type}`, `${data.installments}`)
    return await transactionResult()
}

const tefDebitTransaction = async (data) => {
    TEFModule.startDebitTransaction(`${data.value}`)
    return await transactionResult()
}

const tefPixTransaction = async (data) => {
    TEFModule.startPIXTransaction(`${data.value}`)
    return await transactionResult()
}

export const activateTerminal = async (data) => {
    await TEFModule.automationData("PDVLink", "1.0.0", "TELA ELGIN TEF")
    await TEFModule.activateTerminal(data.document)
    return await transactionResult()
}

export const printLastReceipt = async () => {
    TEFModule.printLastReceipt();
    return await transactionResult()
}




