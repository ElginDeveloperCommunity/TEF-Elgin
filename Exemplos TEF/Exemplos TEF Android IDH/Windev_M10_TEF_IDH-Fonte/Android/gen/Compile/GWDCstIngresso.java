/**
 * Code generated by WINDEV - DO NOT MODIFY!
 * WINDEV object: Structure
 * Android class: stIngresso
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



public class GWDCstIngresso extends WDStructure
{
public WDObjet mWD_horario = new WDChaineA();
public WDObjet mWD_localidade = new WDChaineA();
public WDObjet mWD_quantidade = new WDChaineA();
public WDObjet mWD_nome = new WDChaineA();


public GWDCstIngresso()
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
if(sNomMembre.equals("horario")) return mWD_horario;
if(sNomMembre.equals("localidade")) return mWD_localidade;
if(sNomMembre.equals("quantidade")) return mWD_quantidade;
if(sNomMembre.equals("nome")) return mWD_nome;

return super.getMembreByName(sNomMembre);
}
protected boolean getMembreByIndex(int nIndice, WDClasse.Membre membre)
{
switch(nIndice)
{
case 0 : membre.m_refMembre = mWD_horario; membre.m_strNomMembre = "mWD_horario"; membre.m_bStatique = false; membre.m_strNomMembreWL = "horario"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 1 : membre.m_refMembre = mWD_localidade; membre.m_strNomMembre = "mWD_localidade"; membre.m_bStatique = false; membre.m_strNomMembreWL = "localidade"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 2 : membre.m_refMembre = mWD_quantidade; membre.m_strNomMembre = "mWD_quantidade"; membre.m_bStatique = false; membre.m_strNomMembreWL = "quantidade"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;
case 3 : membre.m_refMembre = mWD_nome; membre.m_strNomMembre = "mWD_nome"; membre.m_bStatique = false; membre.m_strNomMembreWL = "nome"; membre.m_bSerialisable = true; membre.m_strNomSerialisation = null; membre.m_strMapping = null; membre.m_nOptCopie = 0; membre.m_nOptCopieEltTableau = 0; membre.m_bAssocie = false; membre.m_bCleUnique = false; return true;

default: return super.getMembreByIndex(nIndice - 4, membre);
}
}
}
