import 'dart:math';
import 'dart:convert';



    String mudaHexa(int pHexa) {
    var chave = "123456789ABCDEFGHIJKLMNOPQRSTUVXYZ";

    var retorno = pHexa == 0 ? "0" : chave[pHexa - 1];

    return retorno;
  }

   String paraHexa(int pNum) {
    var mNro = "";

    while (pNum >= 34) {
      mNro = mudaHexa(pNum % 34) + mNro;

      pNum = (pNum ~/ 34);
    }

    mNro = mudaHexa(pNum % 34) + mNro;

    return mNro;
  }


     String chkIdent(String mNome) {
    dynamic nAsc, nLen = mNome.length;
    var calc1CI = 0;
    var calc2CI = 0;

    //print("mNome: $mNome nLen: $nLen");

    for (int i = 0; i <= mNome.length - 1; i++) {
      var n = i + 1;
      nLen--;
      nAsc = const AsciiEncoder().convert(mNome[i]);
      nAsc = nAsc[0];
      int n1 = (nAsc * (pow(n, 3)));
      int n2 = (nAsc * (pow(nLen, 3)));
      calc1CI += n1;
      calc2CI += n2;
    }

    String sCalc1CI = paraHexa(calc1CI);
    String sCalc2CI = paraHexa(calc2CI);
    

    sCalc1CI = sCalc1CI.length > 3
        ? sCalc1CI.substring(sCalc1CI.length - 4)
        : sCalc1CI;

    sCalc2CI = sCalc2CI.length > 2
        ? sCalc2CI.substring(sCalc2CI.length - 3)
        : sCalc2CI;
    return sCalc1CI + sCalc2CI;
  }



