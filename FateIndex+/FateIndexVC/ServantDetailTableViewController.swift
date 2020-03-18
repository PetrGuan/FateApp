//
//  ServantDetailTableViewController.swift
//  FateIndex+
//
//  Created by PeterGuan on 2019/10/2.
//  Copyright © 2019 管君. All rights reserved.
//

import UIKit


class ServantDetailTableViewController: UITableViewController {

    private enum Section {
        case basicInfo
        case actionCard
        case npRelated
        case classSkill
        case noblePhantasm
        case activeSkill

        func title() -> String {
            switch self {
            case .basicInfo:
                return "基础数据"
            case .actionCard:
                return "配卡"
            case .npRelated:
                return "NP获得率"
            case .classSkill:
                return "职阶技能"
            case .noblePhantasm:
                return "宝具"
            case .activeSkill:
                return "主动技能"
            }
        }
    }

    private enum Row {

        case id
        case name
        case className
        case rarity
        case cost
        case tenchijin // 天地人特性
        case maxLevel
        case maxLevel_HP
        case maxLevel_ATK

        case card_distribution //  配卡
        case arts_hit
        case quick_hit
        case buster_hit

        case attack_np_gain
        case hurt_np_gain
        case instant_death_possibility
        case star_appear_possibility
        case critical_star_distribution

        case classSkillSummary

        case noblePhantasm

        case activeSkillSummary
    }

    private let servant: Servant

    private var data = FateTableViewData<Section, Row>()

    init(servant: Servant) {
        self.servant = servant

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TrailingTextTableViewCell.self, forCellReuseIdentifier: TrailingTextTableViewCell.identifier)
        tableView.register(TableViewTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewTitleHeaderView.identifier)
        tableView.register(ServantCardSequenceTableViewCell.self, forCellReuseIdentifier: ServantCardSequenceTableViewCell.identifier)
        tableView.register(DisclosureTableViewCell.self, forCellReuseIdentifier: DisclosureTableViewCell.identifier)
        tableView.register(AvatarWithTextTableViewCell.self, forCellReuseIdentifier: AvatarWithTextTableViewCell.identifier)

        update()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    private func update() {
        updateData()
        tableView.reloadData()
    }

    private func updateData() {
        data.removeAll()

        data.append(section: .basicInfo)
        data.append(rows: [.id, .name, .className, .rarity, .cost, .tenchijin, .maxLevel, .maxLevel_HP, .maxLevel_ATK], to: .basicInfo)

        data.append(section: .actionCard)
        data.append(rows: [.card_distribution, .arts_hit, .quick_hit, .buster_hit], to: .actionCard)

        data.append(section: .npRelated)
        data.append(rows: [.attack_np_gain, .hurt_np_gain, .instant_death_possibility, .star_appear_possibility, .critical_star_distribution], to: .npRelated)

        if !servant.classskill.isEmpty {
            data.append(section: .classSkill)
            servant.classskill.forEach { _ in data.append(row: .classSkillSummary, to: .classSkill) }
        }

        data.append(section: .noblePhantasm)
        data.append(row: .noblePhantasm, to: .noblePhantasm)

        data.append(section: .activeSkill)
        data.append(rows: [.activeSkillSummary, .activeSkillSummary, .activeSkillSummary], to: .activeSkill)
    }

}

// MARK: - UITableViewDataSource
extension ServantDetailTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.rowCount(at: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell: UITableViewCell
        switch data.row(at: indexPath) {
        case .id:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("编号", trailingText: servant.servant.no)

            resultCell = cell

        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("姓名", trailingText: servant.servant.name)

            resultCell = cell

        case .className:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("职阶", trailingText: servant.servant.clazz)

            resultCell = cell

        case .rarity:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("稀有度", trailingText: "\(servant.servant.rare)")

            resultCell = cell

        case .cost:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("消耗", trailingText: "\(servant.servant.cost)")

            resultCell = cell

        case .tenchijin:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("天地人特性", trailingText: servant.servant.tenchizin)

            resultCell = cell

        case .maxLevel:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("满级", trailingText: servant.status[0].level)

            resultCell = cell

        case .maxLevel_HP:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            if !servant.status.isEmpty {
                cell.configure("满级 HP", trailingText: "\(servant.status[0].hp)")
            }

            resultCell = cell

        case .maxLevel_ATK:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            if !servant.status.isEmpty {
                cell.configure("满级 ATK", trailingText: "\(servant.status[0].atk)")
            }

            resultCell = cell

        case .card_distribution:
            let cell = tableView.dequeueReusableCell(withIdentifier: ServantCardSequenceTableViewCell.identifier, for: indexPath) as! ServantCardSequenceTableViewCell
            cell.configure(text: "配卡", servant: servant)

            resultCell = cell

        case .arts_hit:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.configure("Arts Hit", trailingText: "\(servant.card.arts.hit)")

            resultCell = cell

        case .quick_hit:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.configure("Quick Hit", trailingText: "\(servant.card.quick.hit)")

            resultCell = cell

        case .buster_hit:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.configure("Buster Hit", trailingText: "\(servant.card.buster.hit)")

            resultCell = cell

        case .attack_np_gain:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("NP获得率(攻击)", trailingText: "\(servant.hidden.na)%")

            resultCell = cell

        case .hurt_np_gain:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("NP获得率(受击)", trailingText: "\(servant.hidden.nd)%")

            resultCell = cell

        case .instant_death_possibility:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("被即死率", trailingText: "\(servant.hidden.dr)%")

            resultCell = cell

        case .star_appear_possibility:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("出星率", trailingText: "\(servant.hidden.staroccurrence)%")

            resultCell = cell

        case .critical_star_distribution:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailingTextTableViewCell.identifier, for: indexPath) as! TrailingTextTableViewCell
            cell.selectionStyle = .none
            cell.configure("暴击星分配权重", trailingText: "\(servant.hidden.starcollection)")

            resultCell = cell

        case .classSkillSummary:
            let cell = tableView.dequeueReusableCell(withIdentifier: AvatarWithTextTableViewCell.identifier, for: indexPath) as! AvatarWithTextTableViewCell

            let classSkill = servant.classskill[indexPath.row]

            cell.avatar = UIImageUtility.classSkillImage(named: classSkill.type)
            cell.title = classSkill.name
            cell.accessoryType = .disclosureIndicator

            resultCell = cell

        case .noblePhantasm:
            let cell = tableView.dequeueReusableCell(withIdentifier: AvatarWithTextTableViewCell.identifier, for: indexPath) as! AvatarWithTextTableViewCell
            let hogu = servant.hogu
            cell.avatar = UIImageUtility.classSkillImage(named: hogu.card)
            cell.title = hogu.name
            cell.accessoryType = .disclosureIndicator

            resultCell = cell

        case .activeSkillSummary:
            let cell = tableView.dequeueReusableCell(withIdentifier: AvatarWithTextTableViewCell.identifier, for: indexPath) as! AvatarWithTextTableViewCell

            let skill: Servant.Skill

            if indexPath.row == 0 {
                skill = servant.skill1
            }
            else if indexPath.row == 1 {
                skill = servant.skill2
            }
            else {
                skill = servant.skill3
            }

            cell.avatar = UIImageUtility.classSkillImage(named: skill.avatar)
            cell.title = skill.name
            cell.accessoryType = .disclosureIndicator

            resultCell = cell
        }

        return resultCell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if indexPath.section == 3 {
            let classSkill = servant.classskill[indexPath.row]

            let vc = ClassSkillDetailViewController(classSkill: classSkill)
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewTitleHeaderView.identifier) as! TableViewTitleHeaderView

        let title: String = {
            switch data.section(at: section) {
            case .basicInfo:
                return "基础数据"
            case .actionCard:
                return "配卡"
            case .npRelated:
                return "NP获得率"
            case .classSkill:
                return "职阶技能"
            case .noblePhantasm:
                return "宝具"
            case .activeSkill:
                return "主动技能"
            }
        }()

        headerView.title = title
        return headerView
    }

}

// MARK: - UITableView Delegate
extension ServantDetailTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 3 {
            let classSkill = servant.classskill[indexPath.row]
            let vc = ClassSkillDetailViewController(classSkill: classSkill)
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        }
        else if indexPath.section == 5 {
            let skill: Servant.Skill
            if indexPath.row == 0 {
                skill = servant.skill1
            }
            else if indexPath.row == 1 {
                skill = servant.skill2
            }
            else {
                skill = servant.skill3
            }

            let vc = ActiveSkillDetailViewController(skill: skill)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
