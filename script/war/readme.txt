##BUFF##
	+增/减生命上限
	+增/减攻击力
	+增/减水晶消耗
	+增/减攻击次数

##状态##
	+生命周期状态
		init -> incardlib -> inhand -> inwar -> die
	+状态
		激怒 | 圣盾 | 魔免 | 物免 | 嘲讽 | 冲锋 | 冻结 | 免疫

##卡牌属性##
	+基本属性：生命值/生命值上限，攻击力，水晶消耗
	+状态：如嘲讽/圣盾等
	+光环：如友方随从生命值+1/左右随从法伤加1等
	+buff：如战吼：左右随从攻击力+1/生命值+1，并具有嘲讽

##事件##
	+英雄攻击(前/中/后，大部分时间都应该有前/中/后阶段，后续不再累叙)
	+英雄受到伤害
	+英雄恢复生命
	+使用技能
	+装备武器
	+销毁武器
	+使用卡牌
	+置入战场
	+移出战场
	+随从死亡
	+随从受到伤害
	+随从恢复生命
	+随从增加生命值上限
	+随从减少生命值上限
	+随从增加攻击力
	+随从减少攻击力
	+随从增加消耗
	+随从较少消耗
	+抽牌
	+爆牌
	+随从状态变化
	+回合开始
	+回合结束

##流程##
	before_beginround
	beginround
	after_beginround
	before_playcard  before_attack
		before_hurt before_recoverhp
		after_hurt  after_recoverhp
		before_die
		after_die
	after_playcard   after_attack

	before_endround
	after_endround
