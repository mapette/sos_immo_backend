import MD5 from 'sha1'
import uuid from 'uuidv4'

const genUuid = () =>  {
    return uuid.uuid()
}

const genMdp = () => {
    let mdp = ''
    let longMdp = 8
    /* charAlpha : chaîne de caractères alphanumérique */
    let charAlpha = 'abcdefghijknopqrstuvwxyzAcDEFGHJKLMNPQRSTUVWXYZ12345679'
    /* charSpe : chaîne de caractères spéciaux */
    let charSpe = '!@#$+-*_'
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

const hash = (id, mdp) =>  {
    return MD5(id + mdp)
}

export {
    genUuid,
    genMdp, 
    hash,  
}
