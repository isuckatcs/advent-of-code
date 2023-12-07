#include <algorithm>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

enum class Kind {
  FIVE_OF_A_KIND = 6,
  FOUR_OF_A_KIND = 5,
  FULL_HOUSE = 4,
  THREE_OF_A_KIND = 3,
  TWO_PAIR = 2,
  ONE_PAIR = 1,
  HIGH_CARD = 0
};

bool JOKERS = false;

Kind getKind(const std::string &hand) {
  std::map<char, int> counts;

  for (auto &&c : hand) {
    counts[c] += 1;
  }

  bool hasNonJokerPair = false;
  bool hasNonJokerTriplet = false;
  int jokers = JOKERS ? counts['J'] : 0;

  for (auto [c, cnt] : counts) {
    bool isJoker = JOKERS && c == 'J';

    switch (cnt) {
    case 5: {
      return Kind::FIVE_OF_A_KIND;
    }
    case 4: {
      if (isJoker || jokers == 1)
        return Kind::FIVE_OF_A_KIND;

      return Kind::FOUR_OF_A_KIND;
    }
    case 3: {
      if ((isJoker && hasNonJokerPair) || jokers == 2)
        return Kind::FIVE_OF_A_KIND;

      if (jokers == 1)
        return Kind::FOUR_OF_A_KIND;

      if (hasNonJokerPair)
        return Kind::FULL_HOUSE;

      hasNonJokerTriplet = !isJoker;
      break;
    }
    case 2: {
      if ((isJoker && hasNonJokerTriplet) || jokers == 3)
        return Kind::FIVE_OF_A_KIND;

      if ((isJoker && hasNonJokerPair) || (!isJoker && jokers == 2))
        return Kind::FOUR_OF_A_KIND;

      if (hasNonJokerTriplet)
        return Kind::FULL_HOUSE;

      if (hasNonJokerPair)
        return jokers == 1 ? Kind::FULL_HOUSE : Kind::TWO_PAIR;

      hasNonJokerPair = !isJoker;
    }
    }
  }

  if (jokers == 3)
    return Kind::FOUR_OF_A_KIND;

  if (jokers == 2 || hasNonJokerTriplet)
    return Kind::THREE_OF_A_KIND;

  if (jokers == 1 || hasNonJokerPair)
    return (jokers == 1 && hasNonJokerPair) ? Kind::THREE_OF_A_KIND
                                            : Kind::ONE_PAIR;

  return Kind::HIGH_CARD;
};

int getCardStrength(char c) {
  switch (c) {
  case 'A':
    return 14;
  case 'K':
    return 13;
  case 'Q':
    return 12;
  case 'J':
    return JOKERS ? 1 : 11;
  case 'T':
    return 10;
  default:
    return c - '0';
  }
}

using HandsType = std::pair<std::string, int>;

bool cardValueLess(const HandsType &a, const HandsType &b) {
  Kind aKind = getKind(a.first);
  Kind bKind = getKind(b.first);

  if (aKind == bKind) {
    size_t i = 0;
    while (i < a.first.size() && a.first[i] == b.first[i]) {
      ++i;
    }

    return getCardStrength(a.first[i]) < getCardStrength(b.first[i]);
  }

  return aKind < bKind;
}

size_t part1(const std::vector<std::string> &lines) {
  std::vector<HandsType> hands;
  std::string hand;
  int bid = 0;

  for (auto &&line : lines) {
    std::stringstream ss(line);
    ss >> hand >> bid;
    hands.emplace_back(hand, bid);
  }

  std::sort(hands.begin(), hands.end(), cardValueLess);

  size_t winnings = 0;
  for (size_t i = 0; i < hands.size(); ++i) {
    winnings += (i + 1) * hands[i].second;
  }

  return winnings;
};

size_t part2(const std::vector<std::string> &lines) {
  std::vector<HandsType> hands;
  std::string hand;
  int bid = 0;

  for (auto &&line : lines) {
    std::stringstream ss(line);
    ss >> hand >> bid;
    hands.emplace_back(hand, bid);
  }

  JOKERS = true;
  std::sort(hands.begin(), hands.end(), cardValueLess);

  size_t winnings = 0;
  for (size_t i = 0; i < hands.size(); ++i) {
    winnings += (i + 1) * hands[i].second;
  }

  return winnings;
}

int main() {
  std::vector<std::string> lines;

  std::string line;
  while (std::getline(std::cin, line)) {
    lines.emplace_back(line);
  }

  std::cout << part1(lines) << '\n';
  std::cout << part2(lines) << '\n';

  return 0;
}
