class Dica {
  final String titulo, texto;
  const Dica(this.titulo, this.texto);
}

class Musica {
  final String titulo, artista, videoId;
  const Musica(this.titulo, this.artista, this.videoId);
}

const dicasCuidador = <Dica>[
  Dica(
    'Rotina consistente',
    'Mantenha uma rotina diária previsível. Pessoas no espectro autista se beneficiam de saber o que esperar ao longo do dia. Use apoios visuais, como calendários e quadros de rotina.',
  ),
  Dica(
    'Ambiente sensorial',
    'Reduza estímulos sensoriais em excesso. Mantenha luzes suaves, diminua o barulho e ofereça espaços calmos. Observe quais estímulos mais incomodam a pessoa.',
  ),
  Dica(
    'Comunicação visual',
    'Use apoios visuais (PECS, imagens, símbolos) para complementar a comunicação verbal. Dê tempo para a pessoa processar a informação antes de repetir ou reformular.',
  ),
  Dica(
    'Transições tranquilas',
    'Avise com antecedência sobre mudanças de atividade. Use temporizadores visuais e contagem regressiva para ajudar na troca entre atividades.',
  ),
  Dica(
    'Reforço positivo',
    'Comemore conquistas e comportamentos positivos. Use elogios específicos e concretos. Evite frases vagas como "muito bem" — prefira "Você guardou seus brinquedos, parabéns!".',
  ),
  Dica(
    'Sinais de sobrecarga',
    'Aprenda a identificar sinais de sobrecarga sensorial: tapar os ouvidos, balançar o corpo, evitar o olhar. Ofereça um espaço calmo quando notar esses sinais.',
  ),
  Dica(
    'Alimentação',
    'Respeite as preferências alimentares e apresente alimentos novos aos poucos. Muitas pessoas autistas têm sensibilidade a texturas e sabores.',
  ),
  Dica(
    'Hora de dormir',
    'Crie uma rotina de sono relaxante e constante. Reduza estímulos visuais e sonoros antes de dormir. Considere luzes noturnas suaves e cobertores pesados.',
  ),
];

const musicasRelaxantes = <Musica>[
  Musica('Música relaxante para crianças', 'Sons da natureza', 'hlWiI4xVXKY'),
  Musica('Canções calmas para crianças', 'Canções de ninar', '77ZozI0rw7w'),
  Musica('Sons da natureza - Pássaros', 'Natureza', 'rYoZgpAEkFs'),
  Musica('Música clássica para relaxar', 'Clássicos', 'HMnrl0tmd3k'),
];
