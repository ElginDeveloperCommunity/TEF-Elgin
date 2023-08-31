/**
 * Code generated by WINDEV - DO NOT MODIFY!
 * WINDEV object: Structure
 * Android class: stBar
 * Version of wdjava64.dll: 28.0.464.1
 */


package com.mycompany.ilumination_park.wdgen;


import com.mycompany.ilumination_park.*;
import fr.pcsoft.wdjava.core.types.*;
import fr.pcsoft.wdjava.core.*;
import fr.pcsoft.wdjava.core.poo.*;
import fr.pcsoft.wdjava.core.application.*;
/*Imports trouvés dans le code WL*/
/*Fin Imports trouvés dans le code WL*/



public class GWDCstBar extends WDStructure
{
public WDObjet mWD_descricao = new WDChaineA();
public WDObjet mWD_qtd = new WDNumerique(32, 6);
public WDObjet mWD_valor = new WDNumerique(32, 6);
public WDObjet mWD_total = new WDNumerique(32, 6);
public WDObjet mWD_id = new WDChaineA();
public WDObjet mWD_tipo = new WDChaineA();


public GWDCstBar()
{
}

public WDProjet getProjet()
{
return GWDPIlumination_Park.getInstance();
}

public IWDEnsembleElement getEnsemble()
{
return GWDPIlumination_Park.getInstance();
}
public int getModeContexteHF()
{
return 1;
}
protected WDObjet getMembreByName(String sNomMembre)
{
if(sNomMembre.equals("descricao")) return mWD_descricao;
if(sNomMembre.equals("qtd")) return mWD_qtd;
if(sNomMembre.equals("valor")) return mWD_valor;
if(sNomMembre.equals("total")) return mWD_total;
if(sNomMembre.equals("id")) return mWD_id;
if(sNomMembre.equals("tipo")) return mWD_tipo;

return super.getMembreByName(sNomMembre);
}
protected boolean getMembreByIndex(int nIndice, WDClasse.Membre membre)
{
switch(nIndice)
{
case 0 : membre.m_refMembre = mWD_descricao; membre.m_strNomMembre = "mWD_descricao"; membre.m_bStatique = false; membre.m_strNomMembreWL = "descricao"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 1 : membre.m_refMembre = mWD_qtd; membre.m_strNomMembre = "mWD_qtd"; membre.m_bStatique = false; membre.m_strNomMembreWL = "qtd"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 2 : membre.m_refMembre = mWD_valor; membre.m_strNomMembre = "mWD_valor"; membre.m_bStatique = false; membre.m_strNomMembreWL = "valor"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 3 : membre.m_refMembre = mWD_total; membre.m_strNomMembre = "mWD_total"; membre.m_bStatique = false; membre.m_strNomMembreWL = "total"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 4 : membre.m_refMembre = mWD_id; membre.m_strNomMembre = "mWD_id"; membre.m_bStatique = false; membre.m_strNomMembreWL = "id"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 5 : membre.m_refMembre = mWD_tipo; membre.m_strNomMembre = "mWD_tipo"; membre.m_bStatique = false; membre.m_strNomMembreWL = "tipo"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;

default: return super.getMembreByIndex(nIndice - 6, membre);
}
}
}