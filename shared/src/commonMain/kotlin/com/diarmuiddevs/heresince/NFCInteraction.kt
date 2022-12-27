package com.diarmuiddevs.heresince

class NFCInteraction {

    fun readTag(showModal: Boolean, launchNFCSession: Boolean) {
//        use nfc to get UID

//        send UID to backend

//        return readTagResponse

    }
}

// this all may be used on backend too, will determine
enum class ResponseToJar { JARHASDATA,JARNODATA,NOTREGISTERED}

class ReadTagResponse(
    type: ResponseToJar,
    response: Any
)