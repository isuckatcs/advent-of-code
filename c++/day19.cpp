#include <iostream>
#include <map>
#include <queue>
#include <sstream>
#include <string>
#include <vector>

struct WorkflowItem {
  char category;
  char op;
  int size;
  std::string destination;
};

struct Part {
  int x;
  int m;
  int a;
  int s;
};

size_t part1(const std::map<std::string, std::vector<WorkflowItem>> &workflows,
             const std::vector<Part> &parts) {
  size_t sum = 0;
  for (auto &&[x, m, a, s] : parts) {
    std::string curWorkflow = "in";

    while (curWorkflow != "A" && curWorkflow != "R") {
      for (auto &&[c, o, ws, d] : workflows.at(curWorkflow)) {

        if (c == '.') {
          curWorkflow = d;
          break;
        }

        bool less = o == '<';
        bool hit = false;

        if (c == 'x')
          hit = less ? x < ws : x > ws;
        else if (c == 'm')
          hit = less ? m < ws : m > ws;
        else if (c == 'a')
          hit = less ? a < ws : a > ws;
        else if (c == 's')
          hit = less ? s < ws : s > ws;

        if (hit) {
          curWorkflow = d;
          break;
        }
      }
    }

    if (curWorkflow == "A")
      sum += x + m + a + s;
  }

  return sum;
}

struct State {
  std::string cur;
  std::pair<int, int> x{1, 4000};
  std::pair<int, int> m{1, 4000};
  std::pair<int, int> a{1, 4000};
  std::pair<int, int> s{1, 4000};
};

size_t
part2(const std::map<std::string, std::vector<WorkflowItem>> &workflows) {
  size_t combinations = 0;
  std::queue<State> q;
  q.emplace("in");

  while (!q.empty()) {
    auto st = q.front();
    q.pop();

    if (st.cur == "R")
      continue;

    if (st.cur == "A") {
      combinations += static_cast<size_t>(st.x.second - st.x.first + 1) *
                      (st.m.second - st.m.first + 1) *
                      (st.a.second - st.a.first + 1) *
                      (st.s.second - st.s.first + 1);

      continue;
    }

    for (auto &&[c, o, s, d] : workflows.at(st.cur)) {
      st.cur = d;

      if (c == '.') {
        q.emplace(st);
        break;
      }

      State nst = st;

      bool less = o == '<';
      if (c == 'x') {
        if (less) {
          nst.x.second = s - 1;
          st.x.first = s;
        } else {
          nst.x.first = s + 1;
          st.x.second = s;
        }
      } else if (c == 'm') {
        if (less) {
          nst.m.second = s - 1;
          st.m.first = s;
        } else {
          nst.m.first = s + 1;
          st.m.second = s;
        }
      } else if (c == 'a') {
        if (less) {
          nst.a.second = s - 1;
          st.a.first = s;
        } else {
          nst.a.first = s + 1;
          st.a.second = s;
        }
      } else if (c == 's') {
        if (less) {
          nst.s.second = s - 1;
          st.s.first = s;
        } else {
          nst.s.first = s + 1;
          st.s.second = s;
        }
      }

      q.emplace(nst);
    }
  }

  return combinations;
}

int main() {
  std::map<std::string, std::vector<WorkflowItem>> workflows;
  std::vector<Part> parts;

  std::string buffer;
  while (std::getline(std::cin, buffer)) {
    if (buffer.empty())
      break;

    std::stringstream ss(buffer);
    std::getline(ss, buffer, '{');

    std::string cur = buffer;
    workflows[cur] = {};

    while (std::getline(ss, buffer, ',')) {

      WorkflowItem item{'.', '.', 0, ""};
      if (buffer.back() == '}') {
        buffer.pop_back();
        item.destination = buffer;
      } else {
        item.category = buffer[0];
        item.op = buffer[1];

        std::stringstream sss(buffer.substr(2));

        std::getline(sss, buffer, ':');
        item.size = std::stoi(buffer);

        std::getline(sss, item.destination);
      }

      workflows[cur].emplace_back(std::move(item));
    }
  }

  while (std::getline(std::cin, buffer)) {
    buffer.pop_back();
    std::stringstream ss(buffer.substr(1));

    Part part{0};
    while (std::getline(ss, buffer, ',')) {
      char c = buffer[0];
      int v = std::stoi(buffer.substr(2));

      if (c == 'x')
        part.x = v;
      else if (c == 'm')
        part.m = v;
      else if (c == 'a')
        part.a = v;
      else if (c == 's')
        part.s = v;
    }
    parts.emplace_back(part);
  }

  std::cout << part1(workflows, parts) << '\n';
  std::cout << part2(workflows) << '\n';

  return 0;
}
