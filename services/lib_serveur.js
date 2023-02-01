import sha1 from 'sha1'
import uuid from 'uuidv4'

const genUuid = () => {
    return uuid.uuid()
}

const genMdp = () => {
    let mdp = ''
    let longMdp = 8
    /* charAlpha : chaîne de caractères alphanumérique */
    let charAlpha = 'abcdefghijknopqrstuvwxyzAcDEFGHJKLMNPQRSTUVWXYZ12345679'
    /* charSpe : chaîne de caractères spéciaux */
    let charSpe = '()!+-*_'
    /* posCharSpe : position du caractère spécial dans le mdp */
    let posCharSpe = Math.floor(Math.random() * (longMdp - 1))
    for (var i = 0; i < longMdp; ++i) {
        if (posCharSpe == i) {
            /* on insère à la position donnée un caractère spécial aléatoire */
            mdp += charSpe.charAt(Math.floor(Math.random() * charSpe.length));
        } else {
            /* on insère un caractère alphanumérique aléatoire */
            mdp += charAlpha.charAt(Math.floor(Math.random() * charAlpha.length));
        }
    }
    return mdp;
}

const hash = (id, mdp) => {
    return sha1(id + mdp)
}

function addDaysToDate(dep, nbDays) {
    // ajouter nbDay à une date dep
    return dep.setDate(dep.getDate() + nbDays);
}

const DELAIS_CLOTURE_AUTO = 172800000 // 48 heures
const DELAIS_VISIBILITE_INC_CLOTURE = 2592000000 // 30 jours

export {
    genUuid,
    genMdp,
    hash,
    addDaysToDate,
    DELAIS_CLOTURE_AUTO,
    DELAIS_VISIBILITE_INC_CLOTURE,
}
